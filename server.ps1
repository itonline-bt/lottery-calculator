# Lottery Calculator - tiny static file server (no install needed)
# Windows PowerShell 5+ , runs without admin rights.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 8777

$mime = @{
  ".html"        = "text/html; charset=utf-8"
  ".htm"         = "text/html; charset=utf-8"
  ".js"          = "application/javascript; charset=utf-8"
  ".css"         = "text/css; charset=utf-8"
  ".json"        = "application/json; charset=utf-8"
  ".webmanifest" = "application/manifest+json; charset=utf-8"
  ".png"         = "image/png"
  ".jpg"         = "image/jpeg"
  ".ico"         = "image/x-icon"
  ".svg"         = "image/svg+xml"
  ".md"          = "text/plain; charset=utf-8"
}

try {
  $listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, $port)
  $listener.Start()
} catch {
  Write-Host "Could not open port $port. Is it already in use?" -ForegroundColor Red
  Read-Host "Press Enter to close"
  exit 1
}

Write-Host ""
Write-Host "  Serving : $root"
Write-Host "  Open    : http://localhost:$port/index.html"
Write-Host "  Stop    : close this window"
Write-Host ""
Start-Process "http://localhost:$port/index.html"

while ($true) {
  $client = $listener.AcceptTcpClient()
  try {
    $stream = $client.GetStream()
    $stream.ReadTimeout = 3000
    $reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::ASCII)
    $request = $reader.ReadLine()
    if ([string]::IsNullOrWhiteSpace($request)) { $client.Close(); continue }

    $parts = $request.Split(" ")
    $rawPath = $parts[1]
    if (-not $rawPath) { $rawPath = "/" }
    $rawPath = ($rawPath.Split("?"))[0]
    $rawPath = [System.Uri]::UnescapeDataString($rawPath)
    if ($rawPath -eq "/") { $rawPath = "/index.html" }

    $rel = $rawPath.TrimStart("/").Replace("/", "\")
    $file = Join-Path $root $rel
    $full = [System.IO.Path]::GetFullPath($file)

    if ($full.StartsWith($root) -and (Test-Path -LiteralPath $full -PathType Leaf)) {
      $bytes = [System.IO.File]::ReadAllBytes($full)
      $ext = [System.IO.Path]::GetExtension($full).ToLower()
      $ct = $mime[$ext]
      if (-not $ct) { $ct = "application/octet-stream" }
      $head = "HTTP/1.1 200 OK`r`nContent-Type: $ct`r`nContent-Length: $($bytes.Length)`r`nCache-Control: no-cache`r`nConnection: close`r`n`r`n"
    } else {
      $bytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
      $head = "HTTP/1.1 404 Not Found`r`nContent-Type: text/plain; charset=utf-8`r`nContent-Length: $($bytes.Length)`r`nConnection: close`r`n`r`n"
    }

    $hb = [System.Text.Encoding]::ASCII.GetBytes($head)
    $stream.Write($hb, 0, $hb.Length)
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Flush()
  } catch {
  } finally {
    $client.Close()
  }
}
