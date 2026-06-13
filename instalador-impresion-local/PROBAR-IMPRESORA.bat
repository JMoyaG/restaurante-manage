@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-RestMethod 'http://127.0.0.1:5055/test-print' | ConvertTo-Json"
pause
