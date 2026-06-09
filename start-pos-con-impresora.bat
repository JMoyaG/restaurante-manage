@echo off
cd /d %~dp0

echo ================================
echo Gato Calavera POS + Impresora LAN
echo ================================
echo.

if not exist node_modules (
  echo Instalando dependencias...
  npm install
)

echo Levantando servicio de impresion en 127.0.0.1:5055...
start "Gato Print Service" cmd /k "node print-service\server.cjs"

echo Levantando POS...
start "Gato Calavera POS" cmd /k "npm run dev"

echo.
echo Para probar impresora:
echo http://127.0.0.1:5055/test-print
echo.
