Set-Location -Path $PSScriptRoot
if (-not (Test-Path lib)) { New-Item -ItemType Directory lib -Force }
Write-Host "Launching Organic Seed Marketplace (classpath: bin;lib/*)"
java -cp "bin;lib/*" com.oseed.ui.LandingFrame
