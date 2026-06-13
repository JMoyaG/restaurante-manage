@echo off
echo ==== HEALTH ====
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-RestMethod 'http://127.0.0.1:5055/health' | ConvertTo-Json -Depth 5 } catch { Write-Host $_.Exception.Message }"
echo.
echo ==== TAREA ====
schtasks /Query /TN "GatoCalaveraPrintService" /V /FO LIST
echo.
echo ==== LOG ====
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "if(Test-Path 'C:\GatoCalavera\logs\print-service.log'){ Get-Content 'C:\GatoCalavera\logs\print-service.log' -Tail 80 } else { 'Sin log' }"
pause
