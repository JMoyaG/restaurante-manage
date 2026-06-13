@echo off
setlocal
cls
echo Arranque manual del servicio para diagnostico...
echo Si hay error, copie esta ventana.
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\GatoCalavera\print-service\service.ps1"
pause
