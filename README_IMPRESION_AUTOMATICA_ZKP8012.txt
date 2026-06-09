IMPRESION AUTOMATICA ZKP8012 80MM

Esta version intenta imprimir automaticamente antes de abrir la ventana de Chrome.

Como funciona:
1. El POS manda factura/comanda/cierre a http://127.0.0.1:5055/print
2. El servicio local detecta una impresora instalada en Windows con nombre parecido a:
   ZKP8012, ZKP, Zjiang, Thermal, Receipt o 80
3. Si la encuentra, manda texto ESC/POS directo y corta el papel.
4. Si el servicio no esta levantado o falla, el POS usa la impresion normal del navegador como respaldo.

Uso rapido:
1. Instalar el driver de la impresora ZKP8012 en Windows.
2. Verificar que Windows la vea en Impresoras y escaneres.
3. Ejecutar: start-pos-con-impresora.bat
4. Entrar al POS y cobrar/imprimir.

Comandos manuales:
- npm run print-service
- npm run dev

Pruebas:
- Abrir http://127.0.0.1:5055/status
- Abrir http://127.0.0.1:5055/printers

Forzar nombre de impresora:
Si Windows la tiene con otro nombre, en PowerShell:
setx ZKP_PRINTER_NAME "Nombre exacto de la impresora"

Nota importante:
Windows debe reconocer la impresora. Ninguna app web puede imprimir a USB sin driver o sin un servicio local.
