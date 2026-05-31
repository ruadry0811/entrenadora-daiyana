# Actualiza el plan en GitHub Pages con el HTML mas reciente generado por la skill
param([string]$RutaHTML)

$RepoPath = "C:\Users\Daiyana Chaparro\Desktop\Desarrollos\entrenadora-daiyana"
$env:PATH = "C:\Program Files\GitHub CLI;" + $env:PATH

# Si no se pasa ruta, busca el mas reciente en Downloads
if (!$RutaHTML) {
    $archivo = Get-ChildItem "$env:USERPROFILE\Downloads\entrenadora*.html" |
               Sort-Object LastWriteTime -Descending |
               Select-Object -First 1
    if (!$archivo) {
        Write-Host "No se encontro ningun archivo entrenadora*.html en Downloads"
        exit 1
    }
    $RutaHTML = $archivo.FullName
}

if (!(Test-Path $RutaHTML)) {
    Write-Host "Archivo no encontrado: $RutaHTML"
    exit 1
}

Copy-Item $RutaHTML "$RepoPath\index.html" -Force
Set-Location $RepoPath

$cambios = git status --porcelain
if (!$cambios) {
    Write-Host "Sin cambios nuevos."
    exit 0
}

git add index.html
$fecha = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "Actualizar plan - $fecha"
git push

Write-Host ""
Write-Host "Plan actualizado en: https://ruadry0811.github.io/entrenadora-daiyana/"
