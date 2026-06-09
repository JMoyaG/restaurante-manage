const http = require('http');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { execFileSync } = require('child_process');

const PORT = Number(process.env.GATO_PRINT_PORT || 5055);
const MATCH = process.env.ZKP_PRINTER_NAME || 'ZKP8012|ZKP|Zjiang|Thermal|Receipt|80';

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
    .replace(/[^\x09\x0A\x0D\x20-\x7E]/g, '')
    .replace(/\n/g, '\r\n');
}

function makeEscpos(text) {
  const init = Buffer.from([0x1b, 0x40, 0x1b, 0x61, 0x00]); // init, left align
  const body = Buffer.from(normalizeText(text), 'ascii');
  const feedCut = Buffer.from([0x0a, 0x0a, 0x0a, 0x1d, 0x56, 0x42, 0x00]);
  return Buffer.concat([init, body, feedCut]);
}

function rawPrint(printerName, text) {
  const tmp = path.join(os.tmpdir(), `gato-calavera-ticket-${Date.now()}.bin`);
  fs.writeFileSync(tmp, makeEscpos(text));
  const script = path.join(__dirname, 'raw-print.ps1');
  try {
    ps(['-File', script, printerName, tmp]);
  } finally {
    setTimeout(() => fs.existsSync(tmp) && fs.unlinkSync(tmp), 1500).unref();
  }
}

const server = http.createServer((req, res) => {
  if (req.method === 'OPTIONS') return send(res, 200, { ok: true });
  if (req.method === 'GET' && req.url === '/status') {
    try {
      const printer = pickPrinter();
      return send(res, 200, { ok: true, printer, match: MATCH });
    } catch (error) {
      return send(res, 500, { ok: false, error: String(error.message || error) });
    }
  }
  if (req.method === 'GET' && req.url === '/printers') {
    try {
      return send(res, 200, { ok: true, printers: listPrinters(), selected: pickPrinter(), match: MATCH });
    } catch (error) {
      return send(res, 500, { ok: false, error: String(error.message || error) });
    }
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
        const printer = pickPrinter();
        if (!printer?.Name) return send(res, 404, { ok: false, error: 'No se encontro impresora ZKP8012/Thermal/Receipt instalada en Windows.' });
        rawPrint(printer.Name, texto);
        return send(res, 200, { ok: true, printer: printer.Name });
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
  try {
    const printer = pickPrinter();
    console.log('Impresora detectada:', printer?.Name || 'ninguna');
  } catch (error) {
    console.log('No se pudo listar impresoras:', error.message || error);
  }
});
