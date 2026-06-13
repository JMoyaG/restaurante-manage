@echo off
echo Este instalador debe ejecutarse como Administrador.
echo Instala la termica USB como TERMICA.
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0print-service\instalar-termica-usb.ps1"
echo.
pause
