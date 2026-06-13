@echo off
net session >nul 2>&1
if not %errorlevel%==0 (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b 0
)
echo Reparando arranque automatico GatoCalaveraPrintService...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*GatoCalavera*print-service*service.ps1*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue } } catch {}"
schtasks /Delete /TN "GatoCalaveraPrintService" /F >nul 2>&1
set "TASK_CMD=powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\GatoCalavera\print-service\service.ps1"
schtasks /Create /TN "GatoCalaveraPrintService" /SC ONLOGON /TR "%TASK_CMD%" /RL HIGHEST /F
if errorlevel 1 (echo ERROR creando tarea & pause & exit /b 1)
schtasks /Run /TN "GatoCalaveraPrintService"
timeout /t 5 /nobreak >nul
powershell.exe -NoProfile -Command "try { Invoke-RestMethod 'http://127.0.0.1:5055/health' -TimeoutSec 8 | ConvertTo-Json -Depth 5 } catch { $_.Exception.Message }"
pause
