GATO CALAVERA - IMPRESION TERMICA LOCAL
=======================================

Esta version ya viene conectada al servicio local de impresion.

FLUJO:
POS React -> http://127.0.0.1:5055/print -> impresora Windows TERMICA

IMPORTANTE:
La impresora debe existir en Windows con el nombre: TERMICA
En la prueba actual funciono asi:
- Driver: Generic / Text Only
- Puerto: USB001
- Nombre: TERMICA

COMO USAR EN LA COMPUTADORA DEL RESTAURANTE
-------------------------------------------
1) Instalar Node.js.
2) Conectar y encender la termica por USB.
3) Si Windows no muestra TERMICA, ejecutar como administrador:
   instalar-impresora-termica.bat
4) Abrir:
   start-pos-con-impresora.bat
5) Validar estado:
   http://127.0.0.1:5055/health
6) Probar impresion:
   http://127.0.0.1:5055/test-print
7) Abrir el POS desde la URL que muestra Vite, normalmente:
   http://127.0.0.1:5173

BOTONES CONECTADOS A LA IMPRESORA
---------------------------------
- Imprimir comanda
- Cobrar / imprimir factura
- Reimprimir factura
- Imprimir cierre
- Probar impresora desde Caja

CONFIGURACION
-------------
Archivo:
print-service/printer.config.json

Por defecto esta asi:
- servicePort: 5055
- preferLan: false
- windowsPrinterNameMatch: ^TERMICA$|Printer POS-80|POS-80|Thermal|Receipt|80

Si algun dia se usa LAN, cambiar preferLan a true y configurar printerIp/printerPort.
Para esta entrega se deja en USB/Windows porque fue lo que ya imprimio correctamente.
