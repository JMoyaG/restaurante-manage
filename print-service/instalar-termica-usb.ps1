# Ejecutar como Administrador.
# Instala la impresora termica USB como TERMICA usando el driver Generic / Text Only.

$ErrorActionPreference = "Stop"
$printerName = "TERMICA"
$driverName = "Generic / Text Only"
$inf = "$env:windir\INF\ntprint.inf"

Write-Host "Buscando puerto USB de la termica..."
$port = Get-PrinterPort | Where-Object {
  $_.Name -match '^USB' -and ($_.Description -match 'POS|Thermal|Receipt|PrinterPOS|80' -or $_.Name -match '^USB')
} | Select-Object -First 1

if (-not $port) {
  throw "No encontre puerto USB de impresora. Conecte la termica, enciendala y vuelva a ejecutar."
}

Write-Host "Puerto detectado: $($port.Name) $($port.Description)"

if (Get-Printer -Name $printerName -ErrorAction SilentlyContinue) {
  Write-Host "La impresora $printerName ya existe. No se vuelve a crear."
  Get-Printer -Name $printerName | Format-Table Name,DriverName,PortName,Shared
  exit 0
}

if (-not (Test-Path $inf)) {
  throw "No encontre $inf"
}

Write-Host "Instalando $printerName en $($port.Name)..."
rundll32 printui.dll,PrintUIEntry /if /b "$printerName" /f "$inf" /r "$($port.Name)" /m "$driverName"
Start-Sleep -Seconds 2

Get-Printer -Name $printerName | Format-Table Name,DriverName,PortName,Shared
Write-Host "Listo. Pruebe con: 'PRUEBA GATO CALAVERA' | Out-Printer -Name TERMICA"
