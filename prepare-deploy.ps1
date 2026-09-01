# Script de preparation pour deploiement GitHub
# Cree un dossier "deploy" avec tous les fichiers necessaires

Write-Host "Preparation du deploiement GitHub Pages..." -ForegroundColor Cyan
Write-Host ""

# Creer le dossier deploy
$deployPath = ".\deploy"
if (Test-Path $deployPath) {
    Write-Host "Le dossier 'deploy' existe deja. Suppression..." -ForegroundColor Yellow
    Remove-Item $deployPath -Recurse -Force
}

New-Item -ItemType Directory -Path $deployPath | Out-Null
Write-Host "[OK] Dossier 'deploy' cree" -ForegroundColor Green

# Copier les fichiers HTML
Write-Host "Copie des fichiers HTML..."
Copy-Item "mobile.html" $deployPath
Copy-Item "index.html" $deployPath
Copy-Item "scanner-dc74.html" $deployPath
Write-Host "[OK] Fichiers HTML copies" -ForegroundColor Green

# Copier le dossier shared
Write-Host "Copie du dossier shared/..."
Copy-Item "shared" $deployPath -Recurse
Write-Host "[OK] Dossier shared copie" -ForegroundColor Green

# Copier les fichiers de configuration
Write-Host "Copie des fichiers de configuration..."
Copy-Item ".gitignore" $deployPath -Force
Copy-Item "README.md" $deployPath
Copy-Item "DEPLOY.md" $deployPath
Write-Host "[OK] Fichiers de configuration copies" -ForegroundColor Green

Write-Host ""
Write-Host "PREPARATION TERMINEE!" -ForegroundColor Green
Write-Host ""
Write-Host "Tous les fichiers sont dans le dossier:" -ForegroundColor Cyan
Write-Host "   $((Get-Item $deployPath).FullName)" -ForegroundColor White
Write-Host ""
Write-Host "PROCHAINES ETAPES:" -ForegroundColor Yellow
Write-Host "   1. Ouvrez le dossier 'deploy' dans l'Explorateur Windows"
Write-Host "   2. Selectionnez TOUS les fichiers a l'interieur"
Write-Host "   3. Glissez-deposez sur GitHub.com dans votre nouveau repository"
Write-Host ""
Write-Host "Consultez DEPLOY.md pour les instructions detaillees!" -ForegroundColor Cyan
Write-Host ""

# Ouvrir le dossier dans l'Explorateur
Write-Host "Ouverture du dossier deploy..." -ForegroundColor Cyan
Start-Process explorer.exe -ArgumentList (Get-Item $deployPath).FullName

Write-Host "Pret pour le deploiement!" -ForegroundColor Green
