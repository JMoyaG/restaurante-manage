@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-RestMethod 'http://127.0.0.1:5055/test-print' | ConvertTo-Json -Depth 5 } catch { Write-Host $_.Exception.Message }"
pause
