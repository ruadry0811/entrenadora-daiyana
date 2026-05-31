# Publica index.html en GitHub Pages via API (funciona desde cualquier maquina)
param([string]$RutaHTML)

$TOKEN  = $env:GITHUB_ENTRENADORA_TOKEN
if (!$TOKEN) { Write-Host "Falta variable GITHUB_ENTRENADORA_TOKEN"; exit 1 }

$OWNER  = "ruadry0811"
$REPO   = "entrenadora-daiyana"
$FILE   = "index.html"
$APIURL = "https://api.github.com/repos/$OWNER/$REPO/contents/$FILE"

if (!$RutaHTML) {
    $archivo = Get-ChildItem "$env:USERPROFILE\Downloads\entrenadora*.html" |
               Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (!$archivo) { Write-Host "No se encontro entrenadora*.html en Downloads"; exit 1 }
    $RutaHTML = $archivo.FullName
}

$headers   = @{ Authorization = "Bearer $TOKEN"; "User-Agent" = "entrenadora-deploy" }
$shaActual = (Invoke-RestMethod -Uri $APIURL -Headers $headers).sha
$contenido = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($RutaHTML))
$fecha     = Get-Date -Format "yyyy-MM-dd HH:mm"

$body = @{ message = "Actualizar plan - $fecha"; content = $contenido; sha = $shaActual } | ConvertTo-Json
Invoke-RestMethod -Uri $APIURL -Method Put -Headers $headers -Body $body -ContentType "application/json" | Out-Null

Write-Host "Plan publicado en: https://ruadry0811.github.io/entrenadora-daiyana/"
