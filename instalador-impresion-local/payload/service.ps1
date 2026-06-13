$ErrorActionPreference = "Continue"
$PrinterName = "TERMICA"
$Port = 5055
$BaseDir = "C:\GatoCalavera"
$LogDir = Join-Path $BaseDir "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$LogFile = Join-Path $LogDir "print-service.log"

function Write-Log($msg) {
  $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Add-Content -Path $LogFile -Value "[$ts] $msg" -Encoding UTF8
}

function Clean-Text($texto) {
  if ($null -eq $texto) { return "" }
  $s = [string]$texto
  $s = $s.Normalize([Text.NormalizationForm]::FormD)
  $sb = New-Object Text.StringBuilder
  foreach ($ch in $s.ToCharArray()) {
    $cat = [Globalization.CharUnicodeInfo]::GetUnicodeCategory($ch)
    if ($cat -ne [Globalization.UnicodeCategory]::NonSpacingMark) { [void]$sb.Append($ch) }
  }
  $s = $sb.ToString()
  $s = $s -replace "₡", "CRC "
  $s = $s -replace "[^\x09\x0A\x0D\x20-\x7E]", ""
  return $s
}

function Linea() { return ("-" * 42) + "`n" }
function Centro($txt) {
  $t = Clean-Text $txt
  if ($t.Length -gt 42) { $t = $t.Substring(0,42) }
  $n = [Math]::Max(0, [Math]::Floor((42 - $t.Length) / 2))
  return (" " * $n) + $t + "`n"
}
function Col($a, $b) {
  $l = Clean-Text $a
  $r = Clean-Text $b
  if ($l.Length -gt 24) { $l = $l.Substring(0,24) }
  if ($r.Length -gt 17) { $r = $r.Substring(0,17) }
  $spaces = 42 - $l.Length - $r.Length
  if ($spaces -lt 1) { $spaces = 1 }
  return $l + (" " * $spaces) + $r + "`n"
}
function Money($n) {
  try { return "CRC " + ([decimal]$n).ToString("N0", [Globalization.CultureInfo]::GetCultureInfo("es-CR")) }
  catch { return "CRC 0" }
}
function Fecha() { return (Get-Date).ToString("dd/MM/yyyy hh:mm tt", [Globalization.CultureInfo]::GetCultureInfo("es-CR")) }

function Print-Text($texto) {
  $printer = Get-Printer -Name $PrinterName -ErrorAction Stop
  $tmp = Join-Path $env:TEMP ("gato-ticket-" + [Guid]::NewGuid().ToString() + ".txt")
  $content = Clean-Text $texto
  Set-Content -Path $tmp -Value $content -Encoding ASCII
  Get-Content -Raw $tmp | Out-Printer -Name $PrinterName
  Remove-Item $tmp -Force -ErrorAction SilentlyContinue
  Write-Log "Ticket enviado a $PrinterName"
}

function Get-JsonBody($ctx) {
  $reader = New-Object IO.StreamReader($ctx.Request.InputStream, $ctx.Request.ContentEncoding)
  $raw = $reader.ReadToEnd()
  if ([string]::IsNullOrWhiteSpace($raw)) { return @{} }
  try { return $raw | ConvertFrom-Json }
  catch { Write-Log "JSON invalido: $raw"; throw "JSON invalido" }
}

function Set-CorsHeaders($ctx) {
  $origin = $ctx.Request.Headers["Origin"]
  if ([string]::IsNullOrWhiteSpace($origin)) { $origin = "*" }

  # IMPORTANTE: solo se escribe UNA VEZ cada header CORS.
  # Esto corrige el error de Chrome: Access-Control-Allow-Origin: "*, *".
  $ctx.Response.Headers.Set("Access-Control-Allow-Origin", $origin)
  $ctx.Response.Headers.Set("Vary", "Origin")
  $ctx.Response.Headers.Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
  $ctx.Response.Headers.Set("Access-Control-Allow-Headers", "Content-Type, Access-Control-Request-Private-Network, Private-Network-Access-ID, Private-Network-Access-Name")
  $ctx.Response.Headers.Set("Access-Control-Allow-Private-Network", "true")
  $ctx.Response.Headers.Set("Private-Network-Access-Name", "Gato Calavera Print Service")
  $ctx.Response.Headers.Set("Private-Network-Access-ID", "gato-calavera-print-service")
}

function Send-Json($ctx, $status, $obj) {
  $ctx.Response.StatusCode = $status
  Set-CorsHeaders $ctx
  $ctx.Response.ContentType = "application/json; charset=utf-8"
  $json = $obj | ConvertTo-Json -Depth 20
  $bytes = [Text.Encoding]::UTF8.GetBytes($json)
  $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  $ctx.Response.Close()
}

function Build-TestTicket() {
  $t = "`n"
  $t += Centro "GATO CALAVERA"
  $t += Centro "PRUEBA DE IMPRESION"
  $t += Linea
  $t += Col "Impresora" $PrinterName
  $t += Col "Estado" "OK"
  $t += Col "Fecha" (Fecha)
  $t += Linea
  $t += Centro "SERVICIO LOCAL OK V7"
  $t += "`n`n`n"
  return $t
}

function Get-Productos($data) {
  if ($null -eq $data.productos) { return @() }
  if ($data.productos -is [System.Array]) { return $data.productos }
  return @($data.productos)
}

function Build-Factura($data) {
  $productos = Get-Productos $data
  $t = "`n"
  $t += Centro "GATO CALAVERA"
  $t += Centro "FACTURA"
  $t += Linea
  $mesa = if ($data.mesa) { $data.mesa } else { "N/A" }
  $t += Col "Mesa" $mesa
  $t += Col "Fecha" (Fecha)
  $t += Linea
  foreach ($p in $productos) {
    $nombre = Clean-Text $p.nombre
    if ([string]::IsNullOrWhiteSpace($nombre)) { $nombre = "Producto" }
    if ($nombre.Length -gt 32) { $nombre = $nombre.Substring(0,32) }
    $cant = 1
    try { $cant = [decimal]$p.cantidad } catch {}
    $precio = 0
    try { $precio = [decimal]$p.precio } catch {}
    $subtotal = $cant * $precio
    $t += ("{0} x {1}`n" -f $cant, $nombre)
    $t += Col "  Precio" (Money $precio)
    $t += Col "  Subtotal" (Money $subtotal)
    $t += "`n"
  }
  $t += Linea
  $t += Col "TOTAL" (Money $data.total)
  if ($null -ne $data.efectivo) { $t += Col "Efectivo" (Money $data.efectivo) }
  if ($null -ne $data.vuelto) { $t += Col "Vuelto" (Money $data.vuelto) }
  $t += Linea
  $t += Centro "Gracias por su compra"
  $t += "`n`n`n"
  return $t
}

function Build-Comanda($data) {
  $productos = Get-Productos $data
  $t = "`n"
  $t += Centro "GATO CALAVERA"
  $t += Centro "COMANDA"
  $t += Linea
  $mesa = if ($data.mesa) { $data.mesa } else { "N/A" }
  $t += Col "Mesa" $mesa
  $t += Col "Fecha" (Fecha)
  $t += Linea
  foreach ($p in $productos) {
    $nombre = Clean-Text $p.nombre
    if ([string]::IsNullOrWhiteSpace($nombre)) { $nombre = "Producto" }
    if ($nombre.Length -gt 36) { $nombre = $nombre.Substring(0,36) }
    $cant = if ($p.cantidad) { $p.cantidad } else { 1 }
    $t += ("{0} x {1}`n" -f $cant, $nombre)
    if ($p.notas) { $t += "Nota: " + (Clean-Text $p.notas) + "`n" }
    if ($p.llevar -eq $true) { $t += "PARA LLEVAR`n" }
    $t += "`n"
  }
  $t += Linea
  $t += "`n`n`n"
  return $t
}

function Build-Cierre($data) {
  $t = "`n"
  $t += Centro "GATO CALAVERA"
  $t += Centro "CIERRE DE CAJA"
  $t += Linea
  $t += Col "Fecha" (Fecha)
  if ($data.usuario) { $t += Col "Usuario" $data.usuario }
  if ($null -ne $data.montoInicial) { $t += Col "Inicial" (Money $data.montoInicial) }
  if ($null -ne $data.efectivo) { $t += Col "Efectivo" (Money $data.efectivo) }
  if ($null -ne $data.tarjeta) { $t += Col "Tarjeta" (Money $data.tarjeta) }
  if ($null -ne $data.sinpe) { $t += Col "SINPE" (Money $data.sinpe) }
  if ($null -ne $data.total) { $t += Col "TOTAL" (Money $data.total) }
  $t += Linea
  $t += "`n`n`n"
  return $t
}

try {
  Write-Log "Iniciando servicio V7 en 127.0.0.1:$Port"
  $listener = New-Object Net.HttpListener
  $listener.Prefixes.Add("http://127.0.0.1:$Port/")
  $listener.Start()
  Write-Log "Servicio activo V7"

  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
      $path = $ctx.Request.Url.AbsolutePath.ToLowerInvariant()
      $method = $ctx.Request.HttpMethod.ToUpperInvariant()

      if ($method -eq "OPTIONS") { Send-Json $ctx 200 @{ ok = $true; version = "7.0" }; continue }

      if ($path -eq "/health") {
        $exists = $false
        try { $null = Get-Printer -Name $PrinterName -ErrorAction Stop; $exists = $true } catch {}
        Send-Json $ctx 200 @{ ok = $true; version = "7.0"; port = $Port; service = "GatoCalaveraPrintService"; printer = $PrinterName; printerFound = $exists; printerExists = $exists; message = "Servicio local Gato Calavera activo" }
        continue
      }
      if ($path -eq "/test-print" -or $path -eq "/print/test") {
        Print-Text (Build-TestTicket)
        Send-Json $ctx 200 @{ ok = $true; version = "7.0"; message = "Prueba enviada" }
        continue
      }
      if ($path -eq "/print/factura") {
        $data = Get-JsonBody $ctx
        Print-Text (Build-Factura $data)
        Send-Json $ctx 200 @{ ok = $true; version = "7.0"; message = "Factura enviada" }
        continue
      }
      if ($path -eq "/print/comanda") {
        $data = Get-JsonBody $ctx
        Print-Text (Build-Comanda $data)
        Send-Json $ctx 200 @{ ok = $true; version = "7.0"; message = "Comanda enviada" }
        continue
      }
      if ($path -eq "/print/cierre") {
        $data = Get-JsonBody $ctx
        Print-Text (Build-Cierre $data)
        Send-Json $ctx 200 @{ ok = $true; version = "7.0"; message = "Cierre enviado" }
        continue
      }
      Send-Json $ctx 404 @{ ok = $false; version = "7.0"; error = "Ruta no encontrada" }
    } catch {
      Write-Log "Error request: $($_.Exception.Message)"
      try { Send-Json $ctx 500 @{ ok = $false; version = "7.0"; error = $_.Exception.Message } } catch {}
    }
  }
} catch {
  Write-Log "ERROR FATAL V7: $($_.Exception.Message)"
  Start-Sleep -Seconds 3
  throw
}
