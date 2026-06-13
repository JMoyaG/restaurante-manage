@echo off
net session >nul 2>&1
if not %errorlevel%==0 (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b 0
)
schtasks /Delete /TN "GatoCalaveraPrintService" /F >nul 2>&1
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*GatoCalavera*print-service*service.ps1*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue } } catch {}"
echo Desinstalado.
pause
