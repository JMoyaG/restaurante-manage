const http = require('http');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { execFile } = require('child_process');

const CONFIG_PATH = path.join(__dirname, 'printer.config.json');
const WIDTH = 42;

function readConfig() {
  const defaults = {
    servicePort: 5055,
    windowsPrinterName: 'TERMICA',
    windowsPrinterNameMatch: 'TERMICA|POS-80|Thermal|Receipt|80',
  };
  try {
    if (!fs.existsSync(CONFIG_PATH)) return defaults;
    return { ...defaults, ...JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf8')) };
  } catch {
    return defaults;
  }
}

const CONFIG = readConfig();
const PORT = Number(process.env.GATO_PRINT_PORT || CONFIG.servicePort || 5055);
const PRINTER_NAME = process.env.GATO_PRINTER_NAME || CONFIG.windowsPrinterName || 'TERMICA';
const MATCH = process.env.GATO_PRINTER_MATCH || CONFIG.windowsPrinterNameMatch || 'TERMICA|POS-80|Thermal|Receipt|80';

function clean(text = '') {
  return String(text || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/₡/g, 'CRC ')
    .replace(/[“”]/g, '"')
    .replace(/[‘’]/g, "'")
    .replace(/[—–]/g, '-')
    .replace(/[^\x09\x0A\x0D\x20-\x7E]/g, '')
    .replace(/\r?\n/g, '\r\n');
}

function money(n) {
  return 'CRC ' + Number(n || 0).toLocaleString('es-CR');
}
function line() { return '-'.repeat(WIDTH) + '\n'; }
function center(text) {
  const t = clean(text).slice(0, WIDTH);
  return ' '.repeat(Math.max(0, Math.floor((WIDTH - t.length) / 2))) + t + '\n';
}
function col(left, right = '') {
  let l = clean(left).slice(0, 24);
  let r = clean(right).slice(0, 17);
  const spaces = Math.max(1, WIDTH - l.length - r.length);
  return l + ' '.repeat(spaces) + r + '\n';
}
function fecha() {
  return new Date().toLocaleString('es-CR', { dateStyle: 'short', timeStyle: 'short' });
}
function productos(data) {
  const p = data?.productos;
  if (!p) return [];
  return Array.isArray(p) ? p : [p];
}
function buildFactura(data = {}) {
  if (data.texto || data.text) return String(data.texto || data.text) + '\n\n\n';
  let t = '\n' + center('GATO CALAVERA') + center('FACTURA') + line();
  t += col('Mesa', data.mesa || 'N/A') + col('Fecha', fecha()) + line();
  for (const p of productos(data)) {
    const nombre = clean(p.nombre || 'Producto').slice(0, 32);
    const cantidad = Number(p.cantidad || 1);
    const precio = Number(p.precio || 0);
    t += `${cantidad} x ${nombre}\n`;
    t += col('  Precio', money(precio));
    t += col('  Subtotal', money(cantidad * precio)) + '\n';
  }
  t += line() + col('TOTAL', money(data.total));
  if (data.efectivo !== undefined) t += col('Efectivo', money(data.efectivo));
  if (data.vuelto !== undefined) t += col('Vuelto', money(data.vuelto));
  t += line() + center('Gracias por su compra') + '\n\n\n';
  return t;
}
function buildComanda(data = {}) {
  if (data.texto || data.text) return String(data.texto || data.text) + '\n\n\n';
  let t = '\n' + center('GATO CALAVERA') + center('COMANDA') + line();
  t += col('Mesa', data.mesa || 'N/A') + col('Fecha', fecha()) + line();
  for (const p of productos(data)) {
    t += `${Number(p.cantidad || 1)} x ${clean(p.nombre || 'Producto').slice(0, 36)}\n`;
    if (p.notas) t += `Nota: ${clean(p.notas).slice(0, 36)}\n`;
    if (p.llevar) t += 'PARA LLEVAR\n';
    t += '\n';
  }
  return t + line() + '\n\n\n';
}
function buildCierre(data = {}) {
  if (data.texto || data.text) return String(data.texto || data.text) + '\n\n\n';
  let t = '\n' + center('GATO CALAVERA') + center('CIERRE DE CAJA') + line();
  t += col('Fecha', fecha());
  if (data.usuario) t += col('Usuario', data.usuario);
  if (data.montoInicial !== undefined) t += col('Inicial', money(data.montoInicial));
  if (data.efectivo !== undefined) t += col('Efectivo', money(data.efectivo));
  if (data.tarjeta !== undefined) t += col('Tarjeta', money(data.tarjeta));
  if (data.sinpe !== undefined) t += col('SINPE', money(data.sinpe));
  if (data.salidas !== undefined) t += col('Salidas', money(data.salidas));
  if (data.total !== undefined) t += col('TOTAL', money(data.total));
  return t + line() + '\n\n\n';
}
function testText() {
  return '\n' + center('GATO CALAVERA') + center('PRUEBA DE IMPRESION') + line() + col('Impresora', PRINTER_NAME) + col('Estado', 'OK') + col('Fecha', fecha()) + line() + center('SERVICIO LOCAL OK') + '\n\n\n';
}

function ps(command) {
  return new Promise((resolve, reject) => {
    execFile('powershell.exe', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', command], { windowsHide: true, timeout: 15000 }, (err, stdout, stderr) => {
      if (err) reject(new Error(stderr || err.message));
      else resolve(stdout);
    });
  });
}
async function printerExists() {
  if (process.platform !== 'win32') return false;
  try {
    await ps(`Get-Printer -Name ${JSON.stringify(PRINTER_NAME)} -ErrorAction Stop | Out-Null`);
    return true;
  } catch {
    return false;
  }
}
async function printText(text) {
  if (process.platform !== 'win32') throw new Error('Este servicio local imprime solo en Windows.');
  const tmp = path.join(os.tmpdir(), `gato-ticket-${Date.now()}.txt`);
  fs.writeFileSync(tmp, clean(text), 'ascii');
  const cmd = `Get-Content -Raw ${JSON.stringify(tmp)} | Out-Printer -Name ${JSON.stringify(PRINTER_NAME)}; Remove-Item ${JSON.stringify(tmp)} -Force -ErrorAction SilentlyContinue`;
  await ps(cmd);
}
async function printRawBytes(bytes) {
  if (process.platform !== 'win32') throw new Error('Este servicio local imprime solo en Windows.');
  const tmp = path.join(os.tmpdir(), `gato-ticket-${Date.now()}.bin`);
  fs.writeFileSync(tmp, Buffer.from(bytes));
  const script = path.join(__dirname, 'raw-print.ps1');
  return new Promise((resolve, reject) => {
    execFile('powershell.exe', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script, '-PrinterName', PRINTER_NAME, '-FilePath', tmp], { windowsHide: true, timeout: 15000 }, (err, stdout, stderr) => {
      try { fs.unlinkSync(tmp); } catch {}
      if (err) reject(new Error(stderr || err.message));
      else resolve(stdout);
    });
  });
}
function esc(...arr) { return arr; }
function buildComandaRaw(data = {}) {
  const items = productos(data);
  const out = [];
  const pushText = (s = '') => out.push(...Buffer.from(clean(s), 'ascii'));
  const addItem = (cantidad, nombre) => {
    const qty = String(cantidad || 1);
    const prefix = (qty + ' ').padEnd(4, ' ');
    const maxChars = 32;
    const available = Math.max(8, maxChars - prefix.length);
    const words = clean(nombre || 'Producto').toUpperCase().split(/\s+/).filter(Boolean);
    const lines = [];
    let current = '';
    for (const word of words) {
      if (!current) current = word;
      else if ((current + ' ' + word).length <= available) current += ' ' + word;
      else { lines.push(current); current = word; }
    }
    if (current) lines.push(current);
    if (!lines.length) lines.push(clean(nombre || 'Producto').toUpperCase());
    out.push(...esc(0x1B, 0x45, 0x01));
    out.push(...esc(0x1D, 0x21, 0x01));
    lines.forEach((line, idx) => pushText(`${idx === 0 ? prefix : ' '.repeat(prefix.length)}${line}\n`));
    out.push(...esc(0x1D, 0x21, 0x00));
    out.push(...esc(0x1B, 0x45, 0x00));
  };
  out.push(...esc(0x1B, 0x40));
  out.push(...esc(0x1B, 0x74, 0x02));
  out.push(...esc(0x1B, 0x61, 0x01));
  pushText('COMANDA\n\n');
  pushText(new Date().toLocaleDateString('es-CR') + '\n\n');
  if (data.mesa) pushText(`${clean(data.mesa)}\n`);
  out.push(...esc(0x1B, 0x61, 0x00));
  pushText(`\nA nombre de: ${clean(data.cliente || 'Cliente contado')}\n`);
  pushText(`Salonero: ${clean(data.usuario || 'Caja')}\n`);
  pushText(`Hora comanda: ${new Date().toLocaleTimeString('es-CR')}\n`);
  pushText(`Mesa: ${clean(data.mesa || 'N/A')}\n`);
  pushText('Pacayas\n\n');
  pushText(line());
  pushText('Cant. Descripcion\n');
  pushText(line());
  for (const p of items) {
    addItem(p.cantidad, p.nombre);
    if (p.notas) pushText(`  Nota: ${clean(p.notas)}\n`);
    if (p.llevar) pushText('  PARA LLEVAR\n');
    pushText(line());
  }
  out.push(...esc(0x1B, 0x61, 0x01));
  pushText('******ULTIMA LINEA******\n\n\n');
  out.push(...esc(0x1D, 0x56, 0x42, 0x00));
  return Buffer.from(out);
}
function send(res, status, obj) {
  res.writeHead(status, {
    'Content-Type': 'application/json; charset=utf-8',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  });
  res.end(JSON.stringify(obj, null, 2));
}
function readBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', (chunk) => {
      body += chunk;
      if (body.length > 1024 * 1024) reject(new Error('Payload muy grande'));
    });
    req.on('end', () => {
      try { resolve(body ? JSON.parse(body) : {}); }
      catch { reject(new Error('JSON invalido')); }
    });
    req.on('error', reject);
  });
}

const server = http.createServer(async (req, res) => {
  try {
    if (req.method === 'OPTIONS') return send(res, 200, { ok: true });
    const url = new URL(req.url, `http://127.0.0.1:${PORT}`);
    const pathName = url.pathname.toLowerCase();

    if (req.method === 'GET' && (pathName === '/health' || pathName === '/status')) {
      return send(res, 200, { ok: true, port: PORT, service: 'GatoCalaveraPrintService', printer: PRINTER_NAME, printerFound: await printerExists(), message: 'Servicio local Gato Calavera activo' });
    }
    if (req.method === 'GET' && (pathName === '/test-print' || pathName === '/print/test')) {
      await printText(testText());
      return send(res, 200, { ok: true, message: 'Prueba enviada', printer: PRINTER_NAME });
    }
    if (req.method === 'POST' && pathName === '/print') {
      const data = await readBody(req);
      const texto = data.texto || data.text;
      if (!texto) throw new Error('Texto vacio para imprimir.');
      await printText(String(texto));
      return send(res, 200, { ok: true, message: 'Ticket enviado', printer: PRINTER_NAME });
    }
    if (req.method === 'POST' && pathName === '/print/factura') {
      await printText(buildFactura(await readBody(req)));
      return send(res, 200, { ok: true, message: 'Factura enviada', printer: PRINTER_NAME });
    }
    if (req.method === 'POST' && pathName === '/print/comanda') {
      await printRawBytes(buildComandaRaw(await readBody(req)));
      return send(res, 200, { ok: true, message: 'Comanda enviada', printer: PRINTER_NAME });
    }
    if (req.method === 'POST' && pathName === '/print/cierre') {
      await printText(buildCierre(await readBody(req)));
      return send(res, 200, { ok: true, message: 'Cierre enviado', printer: PRINTER_NAME });
    }
    return send(res, 404, { ok: false, error: 'Ruta no encontrada' });
  } catch (error) {
    return send(res, 500, { ok: false, error: String(error.message || error) });
  }
});

server.listen(PORT, '127.0.0.1', () => {
  console.log(`GatoCalaveraPrintService listo en http://127.0.0.1:${PORT}`);
  console.log(`Impresora Windows: ${PRINTER_NAME}`);
});
