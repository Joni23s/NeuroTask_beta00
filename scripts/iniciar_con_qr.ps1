# scripts/iniciar_con_qr.ps1
$ErrorActionPreference = "SilentlyContinue"

# 1. Obtener la IP local de la red Wi-Fi / Ethernet
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { 
    $_.InterfaceAlias -notmatch 'vEthernet|Loopback|Virtual|WSL' -and 
    $_.IPAddress -notmatch '^169\.' -and 
    $_.IPAddress -ne '127.0.0.1' 
} | Select-Object -First 1).IPAddress

if (-not $ipAddress) {
    $ipAddress = "192.168.18.10"
}

$port = 8080
$targetUrl = "http://${ipAddress}:${port}"
$qrApiUrl = "https://api.qrserver.com/v1/create-qr-code/?size=380x380&data=$targetUrl"

# 2. Crear una página HTML elegante con el QR
$workspaceRoot = (Get-Item "$PSScriptRoot\..").FullName
$htmlPath = "$workspaceRoot\docs\qr_preview.html"

$htmlContent = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NeuroTask — Escanear con tu Celular</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background-color: #0F172A;
            color: #F8FAFC;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }
        .card {
            background: #1E293B;
            border-radius: 28px;
            padding: 32px;
            text-align: center;
            max-width: 440px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.5);
            border: 1px solid #334155;
        }
        h1 {
            font-size: 24px;
            margin-top: 0;
            color: #38BDF8;
            letter-spacing: 1.5px;
            font-weight: 900;
        }
        p {
            color: #94A3B8;
            font-size: 14px;
            line-height: 1.5;
        }
        .qr-box {
            background: white;
            padding: 16px;
            border-radius: 22px;
            display: inline-block;
            margin: 18px 0;
            box-shadow: 0 10px 30px rgba(56, 189, 248, 0.2);
        }
        .qr-box img {
            display: block;
            width: 280px;
            height: 280px;
        }
        .url-badge {
            background: #0F172A;
            color: #38BDF8;
            font-family: monospace;
            font-size: 16px;
            font-weight: bold;
            padding: 10px 18px;
            border-radius: 12px;
            display: inline-block;
            border: 1px solid rgba(56, 189, 248, 0.4);
            margin-bottom: 14px;
        }
        .tips {
            background: rgba(15, 23, 42, 0.7);
            border-left: 4px solid #38BDF8;
            text-align: left;
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 12px;
            color: #CBD5E1;
            margin-top: 14px;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>NEUROTASK</h1>
        <p>Asegúrate de que tu celular esté en el <strong>mismo Wi-Fi</strong> que esta PC y escanea el código con tu cámara:</p>
        
        <div class="qr-box">
            <img src="$qrApiUrl" alt="Código QR NeuroTask" />
        </div>

        <div>
            <span class="url-badge">$targetUrl</span>
        </div>

        <div class="tips">
            <strong>⚡ Cambios en tiempo real:</strong> Cada vez que guardes código en tu editor, presiona <code>r</code> en la consola y tu teléfono se actualizará al instante.<br><br>
            <strong>📱 Experiencia de App Nativa:</strong> En Chrome/Safari de tu celular, toca los tres puntos y selecciona <em>"Agregar a la pantalla principal"</em> para usarla a pantalla completa.
        </div>
    </div>
</body>
</html>
"@

Set-Content -Path $htmlPath -Value $htmlContent -Encoding UTF8

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " NEUROTASK — SERVIDOR WEB EN VIVO CON QR PARA MÓVIL" -ForegroundColor Yellow
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " IP Local Detectada : $ipAddress" -ForegroundColor Green
Write-Host " URL de Acceso      : $targetUrl" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "Abriendo pantalla de QR para escanear con tu celular..." -ForegroundColor Cyan
Write-Host "En la consola, presiona 'r' para Hot Reload en tu teléfono." -ForegroundColor Cyan
Write-Host ""

Start-Process $htmlPath

Set-Location "$workspaceRoot\flutter_app"
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=$port
