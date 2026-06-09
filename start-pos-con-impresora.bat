@echo off
cd /d %~dp0
start "Gato Print Service" cmd /k "node print-service\server.cjs"
start "Gato Calavera POS" cmd /k "npm run dev"
