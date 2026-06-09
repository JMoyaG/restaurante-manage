const http = require('http');
const fs = require('fs');
const os = require('os');
const net = require('net');
const path = require('path');
const { execFileSync } = require('child_process');

const CONFIG_PATH = path.join(__dirname, 'printer.config.json');

function readConfig() {
  const defaults = {
    servicePort: 5055,
    printerIp: '192.168.1.7',
    printerPort: 9100,
    windowsPrinterNameMatch: 'ZKP8012|ZKP|Zjiang|Thermal|Receipt|80',
    preferLan: true,
  };
  try {
    if (!fs.existsSync(CONFIG_PATH)) return defaults;
    return { ...defaults, ...JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf8')) };
  } catch (error) {
    console.log('No se pudo leer printer.config.json, usando valores por defecto:', error.message || error);
    return defaults;
  }
}

const CONFIG = readConfig();
const PORT = Number(process.env.GATO_PRINT_PORT || CONFIG.servicePort || 5055);
const PRINTER_IP = process.env.ZKP_PRINTER_IP || CONFIG.printerIp || '192.168.1.7';
const PRINTER_PORT = Number(process.env.ZKP_PRINTER_PORT || CONFIG.printerPort || 9100);
const MATCH = process.env.ZKP_PRINTER_NAME || CONFIG.windowsPrinterNameMatch || 'ZKP8012|ZKP|Zjiang|Thermal|Receipt|80';
const PREFER_LAN = String(process.env.ZKP_PREFER_LAN || CONFIG.preferLan || 'true').toLowerCase() !== 'false';

function send(res, status, data) {
  res.writeHead(status, {
    'Content-Type': 'application/json; charset=utf-8',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  });
  res.end(JSON.stringify(data));
}

function ps(args) {
  return execFileSync('powershell.exe', ['-NoProfile', '-ExecutionPolicy', 'Bypass', ...args], {
    encoding: 'utf8',
    windowsHide: true,
    timeout: 15000,
  });
}

function listPrinters() {
  if (process.platform !== 'win32') return [];
  const cmd = 'Get-CimInstance Win32_Printer | Select-Object Name,Default,WorkOffline,PrinterStatus | ConvertTo-Json -Compress';
  const out = ps(['-Command', cmd]).trim();
  if (!out) return [];
  const parsed = JSON.parse(out);
  return Array.isArray(parsed) ? parsed : [parsed];
}

function pickPrinter() {
  const printers = listPrinters();
  const rx = new RegExp(MATCH, 'i');
  return printers.find((p) => rx.test(p.Name || '')) || printers.find((p) => p.Default) || printers[0] || null;
}

function normalizeText(text = '') {
  return String(text)
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/₡/g, 'CRC ')
    .replace(/[“”]/g, '"')
    .replace(/[‘’]/g, "'")
    .replace(/—/g, '-')
    .replace(/–/g, '-')
    .replace(/•/g, '-')
    .replace(/[^	
\x20-\x7E]/g, '')
    .replace(/\n/g, '\r\n');
}

function makeEscpos(text) {
  const init = Buffer.from([0x1b, 0x40]); // init
  const codePage = Buffer.from([0x1b, 0x74, 0x00]); // code page 0, safe ASCII
  const left = Buffer.from([0x1b, 0x61, 0x00]);
  const body = Buffer.from(normalizeText(text), 'ascii');
  const feedCut = Buffer.from([0x0a, 0x0a, 0x0a, 0x1d, 0x56, 0x42, 0x00]); // feed + partial cut
  return Buffer.concat([init, codePage, left, body, feedCut]);
}

function printLan(text) {
  return new Promise((resolve, reject) => {
    const data = makeEscpos(text);
    const socket = new net.Socket();
    let finished = false;

    const done = (error) => {
      if (finished) return;
      finished = true;
      socket.destroy();
      if (error) reject(error);
      else resolve();
    };

    socket.setTimeout(8000);
    socket.once('timeout', () => done(new Error(`Timeout conectando a ${PRINTER_IP}:${PRINTER_PORT}`)));
    socket.once('error', (error) => done(error));
    socket.connect(PRINTER_PORT, PRINTER_IP, () => {
      socket.write(data, (error) => {
        if (error) return done(error);
        socket.end();
      });
    });
    socket.once('close', () => done());
  });
}

function rawPrintWindows(printerName, text) {
  if (process.platform !== 'win32') throw new Error('Impresion Windows solo disponible en Windows.');
  const tmp = path.join(os.tmpdir(), `gato-calavera-ticket-${Date.now()}.bin`);
  fs.writeFileSync(tmp, makeEscpos(text));
  const script = path.join(__dirname, 'raw-print.ps1');
  try {
    ps(['-File', script, printerName, tmp]);
  } finally {
    setTimeout(() => fs.existsSync(tmp) && fs.unlinkSync(tmp), 1500).unref();
  }
}

async function printTicket(text) {
  if (PREFER_LAN && PRINTER_IP) {
    await printLan(text);
    return { mode: 'LAN', printer: `${PRINTER_IP}:${PRINTER_PORT}` };
  }
  const printer = pickPrinter();
  if (!printer?.Name) throw new Error('No se encontro impresora ZKP8012/Thermal/Receipt instalada en Windows.');
  rawPrintWindows(printer.Name, text);
  return { mode: 'WINDOWS_RAW', printer: printer.Name };
}

const testText = () => [
  'GATO CALAVERA PACAYAS',
  'PRUEBA IMPRESORA LAN',
  `IP: ${PRINTER_IP}`,
  `PUERTO: ${PRINTER_PORT}`,
  'MODELO: ZKP8012 80MM',
  'ESC/POS OK',
  '',
  new Date().toLocaleString('es-CR'),
  '',
].join('\n');

const server = http.createServer((req, res) => {
  if (req.method === 'OPTIONS') return send(res, 200, { ok: true });

  if (req.method === 'GET' && req.url === '/status') {
    return send(res, 200, {
      ok: true,
      service: 'GatoCalaveraPrintService',
      preferLan: PREFER_LAN,
      printerIp: PRINTER_IP,
      printerPort: PRINTER_PORT,
      windowsNameMatch: MATCH,
    });
  }

  if (req.method === 'GET' && req.url === '/printers') {
    try {
      return send(res, 200, { ok: true, printers: listPrinters(), selected: pickPrinter(), match: MATCH });
    } catch (error) {
      return send(res, 500, { ok: false, error: String(error.message || error) });
    }
  }

  if (req.method === 'GET' && req.url === '/test-print') {
    printTicket(testText())
      .then((result) => send(res, 200, { ok: true, ...result }))
      .catch((error) => send(res, 500, { ok: false, error: String(error.message || error), printerIp: PRINTER_IP, printerPort: PRINTER_PORT }));
    return;
  }

  if (req.method === 'POST' && req.url === '/print') {
    let body = '';
    req.on('data', (chunk) => {
      body += chunk;
      if (body.length > 1024 * 1024) req.destroy();
    });
    req.on('end', () => {
      try {
        const payload = JSON.parse(body || '{}');
        const texto = payload.texto || payload.text || '';
        if (!texto.trim()) return send(res, 400, { ok: false, error: 'Texto vacio para imprimir.' });
        printTicket(texto)
          .then((result) => send(res, 200, { ok: true, ...result }))
          .catch((error) => send(res, 500, { ok: false, error: String(error.message || error), printerIp: PRINTER_IP, printerPort: PRINTER_PORT }));
      } catch (error) {
        return send(res, 500, { ok: false, error: String(error.message || error) });
      }
    });
    return;
  }

  return send(res, 404, { ok: false, error: 'Ruta no encontrada' });
});

server.listen(PORT, '127.0.0.1', () => {
  console.log(`GatoCalaveraPrintService listo en http://127.0.0.1:${PORT}`);
  console.log(`Modo preferido: ${PREFER_LAN ? 'LAN TCP/IP' : 'Windows RAW'}`);
  console.log(`Impresora LAN: ${PRINTER_IP}:${PRINTER_PORT}`);
  console.log('Prueba: http://127.0.0.1:5055/test-print');
});
