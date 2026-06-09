IMPRESION AUTOMATICA LAN - GATO CALAVERA - ZKP8012 80MM

Configuracion confirmada de la impresora:
- Modelo: ZKP8012 / Thermal Receipt Printer
- Comando: EPSON ESC/POS
- IP: 192.168.1.7
- Puerto: 9100
- Protocolo: TCP/IP
- Papel: 80mm
- Corte: YES

IMPORTANTE:
La computadora donde se usa el POS debe estar en la misma red LAN que la impresora.

PRUEBA DE RED EN POWERSHELL:
Test-NetConnection 192.168.1.7 -Port 9100

Tiene que salir:
TcpTestSucceeded : True

COMO LEVANTAR TODO:
1. Abrir PowerShell o doble clic al archivo:
   start-pos-con-impresora.bat

2. Eso abre dos ventanas:
   - Gato Print Service: servicio local de impresion
   - Gato Calavera POS: app del restaurante

3. Probar impresion directa:
   http://127.0.0.1:5055/test-print

FUNCIONAMIENTO:
- El POS manda factura/comanda/cierre a http://127.0.0.1:5055/print
- El servicio local manda el texto directo a 192.168.1.7:9100 por ESC/POS
- Si el servicio no esta abierto o falla, el POS usa impresion normal del navegador como respaldo.

ARCHIVO DE CONFIGURACION:
print-service/printer.config.json

Contenido actual:
{
  "servicePort": 5055,
  "printerIp": "192.168.1.7",
  "printerPort": 9100,
  "windowsPrinterNameMatch": "ZKP8012|ZKP|Zjiang|Thermal|Receipt|80",
  "preferLan": true
}

NOTA SOBRE ACENTOS Y SIMBOLO DE COLON:
La impresora reporta CodePage 0. Para evitar caracteres raros, el servicio convierte acentos y el simbolo ₡ a texto simple CRC.
