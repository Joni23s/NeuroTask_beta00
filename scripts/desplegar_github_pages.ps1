# scripts/desplegar_github_pages.ps1
$ErrorActionPreference = "Stop"

$workspaceRoot = (Get-Item "$PSScriptRoot\..").FullName
$webDir = "$workspaceRoot\flutter_app\build\web"

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "   DESPLIEGUE DE NEUROTASK A GITHUB PAGES       " -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Cyan

# 1. Verificar si existe el bundle compilado
if (-not (Test-Path "$webDir\index.html")) {
    Write-Host "[1/4] Compilando Flutter Web para produccion..." -ForegroundColor Yellow
    Push-Location "$workspaceRoot\flutter_app"
    flutter build web --release --base-href "/NeuroTask_beta00/"
    Pop-Location
} else {
    Write-Host "[1/4] Bundle existente detectado en flutter_app/build/web." -ForegroundColor Green
}

# 2. Ajustar base href y .nojekyll
Write-Host "[2/4] Verificando base-href y .nojekyll..." -ForegroundColor Yellow
$indexPath = "$webDir\index.html"
$indexContent = Get-Content $indexPath -Raw
if ($indexContent -notmatch '<base href="/NeuroTask_beta00/">') {
    $indexContent = $indexContent -replace '<base href="[^"]*">', '<base href="/NeuroTask_beta00/">'
    Set-Content -Path $indexPath -Value $indexContent -Encoding UTF8
    Write-Host "  -> Base href ajustado a /NeuroTask_beta00/" -ForegroundColor Green
}

$nojekyllPath = "$webDir\.nojekyll"
if (-not (Test-Path $nojekyllPath)) {
    Set-Content -Path $nojekyllPath -Value "# GitHub Pages nojekyll" -Encoding UTF8
}

# 3. Publicar en la rama gh-pages de GitHub
Write-Host "[3/4] Publicando en la rama gh-pages..." -ForegroundColor Yellow
$repoUrl = "https://github.com/Joni23s/NeuroTask_beta00.git"

Push-Location $webDir
try {
    if (Test-Path ".git") {
        Remove-Item -Recurse -Force ".git"
    }
    git init -b gh-pages
    git config user.email "jonathanaraujo@users.noreply.github.com"
    git config user.name "Jonathan Araujo"
    git remote add origin $repoUrl
    git add -A
    git commit -m "deploy: update GitHub Pages build $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    git push -f origin gh-pages
    Write-Host "[4/4] Despliegue completado con exito en gh-pages!" -ForegroundColor Green
} catch {
    Write-Host "Error durante el despliegue a gh-pages: $_" -ForegroundColor Red
    throw $_
} finally {
    if (Test-Path ".git") {
        Remove-Item -Recurse -Force ".git"
    }
    Pop-Location
}

Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " URL DE TU APLICACION EN GITHUB PAGES:          " -ForegroundColor Green
Write-Host " https://joni23s.github.io/NeuroTask_beta00/    " -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Cyan
