@echo off
net session >nul 2>&1
if not %errorlevel%==0 (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b 0
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { Unregister-ScheduledTask -TaskName 'GatoCalaveraPrintService' -Confirm:$false -ErrorAction SilentlyContinue } catch {}"
echo Desinstalado. Puede borrar C:\GatoCalavera si desea.
pause
