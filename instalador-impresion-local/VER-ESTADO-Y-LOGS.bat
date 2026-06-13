@echo off
echo === TAREA ===
powershell.exe -NoProfile -Command "Get-ScheduledTask -TaskName 'GatoCalaveraPrintService' -ErrorAction SilentlyContinue | Format-List *"
echo.
echo === HEALTH ===
powershell.exe -NoProfile -Command "try { Invoke-RestMethod 'http://127.0.0.1:5055/health' } catch { $_.Exception.Message }"
echo.
echo === LOG ===
powershell.exe -NoProfile -Command "if(Test-Path 'C:\GatoCalavera\logs\print-service.log'){ Get-Content 'C:\GatoCalavera\logs\print-service.log' -Tail 80 } else { 'Sin log' }"
pause
