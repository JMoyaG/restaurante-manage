@echo off
setlocal EnableExtensions
chcp 65001 >nul
title INSTALADOR IMPRESION LOCAL - GATO CALAVERA V9
color 0A
echo ================================================
echo  INSTALADOR IMPRESION LOCAL - GATO CALAVERA V9
echo  RAW ESC/POS + LOGO + TICKETS BONITOS
echo ================================================
echo.

net session >nul 2>&1
if not %errorlevel%==0 (
  echo Solicitando permisos de administrador...
  powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b 0
)

set "ROOT=%~dp0"
set "SRC=%ROOT%payload\service.ps1"
set "BASE=C:\GatoCalavera"
set "SVC=C:\GatoCalavera\print-service"
set "LOG=C:\GatoCalavera\logs"

if not exist "%SRC%" (
  echo ERROR: No se encontro payload\service.ps1
  echo Extraiga TODO el ZIP en una carpeta y vuelva a ejecutar.
  pause
  exit /b 1
)

mkdir "%SVC%" >nul 2>&1
mkdir "%LOG%" >nul 2>&1

echo [1/6] Deteniendo tarea/proceso anterior si existe...
schtasks /Delete /TN "GatoCalaveraPrintService" /F >nul 2>&1
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*GatoCalavera*print-service*service.ps1*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue } } catch {}" >nul 2>&1

echo [2/6] Instalando servicio local V9...
copy /Y "%SRC%" "%SVC%\service.ps1" >nul
if errorlevel 1 (echo ERROR copiando service.ps1 & pause & exit /b 1)

echo [3/6] Validando impresora TERMICA...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$p=Get-Printer -Name 'TERMICA' -ErrorAction SilentlyContinue; if($p){Write-Host 'OK: TERMICA existe'} else { $port=(Get-PrinterPort | Where-Object { $_.Name -like 'USB*' -or $_.Description -like '*POS*' } | Select-Object -First 1 -ExpandProperty Name); if(-not $port){Write-Host 'ADVERTENCIA: No se encontro TERMICA ni puerto USB de impresora. Instale la termica como TERMICA.'; exit 0}; $driver='Generic / Text Only'; if(-not(Get-PrinterDriver -Name $driver -ErrorAction SilentlyContinue)){ $inf=Join-Path $env:windir 'INF\ntprint.inf'; Start-Process rundll32.exe -ArgumentList ('printui.dll,PrintUIEntry /ia /m "'+$driver+'" /f "'+$inf+'"') -Wait }; Add-Printer -Name 'TERMICA' -DriverName $driver -PortName $port; Write-Host ('TERMICA creada en puerto '+$port) }"

echo [4/6] Registrando arranque automatico...
set "TASK_CMD=powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\GatoCalavera\print-service\service.ps1"
schtasks /Create /TN "GatoCalaveraPrintService" /SC ONLOGON /TR "%TASK_CMD%" /RL HIGHEST /F >nul
if errorlevel 1 (echo ERROR registrando tarea & pause & exit /b 1)

echo [5/6] Iniciando servicio...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-ScheduledTask -TaskName 'GatoCalaveraPrintService'"
timeout /t 4 /nobreak >nul

echo [6/6] Probando servicio...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { $r=Invoke-RestMethod 'http://127.0.0.1:5055/health' -TimeoutSec 8; $r | ConvertTo-Json -Depth 5; exit 0 } catch { Write-Host ('ERROR: '+$_.Exception.Message); exit 1 }"
if errorlevel 1 (
  echo.
  echo No respondio el servicio. Revise logs en C:\GatoCalavera\logs\print-service.log
  pause
  exit /b 1
)

echo.
echo INSTALACION COMPLETA V9.
echo Servicio activo: http://127.0.0.1:5055/health
echo Prueba impresion: http://127.0.0.1:5055/test-print
echo Ahora vuelva al POS de Vercel, haga CTRL+F5 y pruebe factura/comanda.
echo.
pause
exit /b 0
