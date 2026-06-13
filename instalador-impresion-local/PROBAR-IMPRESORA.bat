@echo off
powershell.exe -NoProfile -Command "try { Invoke-RestMethod 'http://127.0.0.1:5055/test-print' } catch { $_.Exception.Message }"
pause
