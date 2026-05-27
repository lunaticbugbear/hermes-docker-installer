param(
  [string]$InstallDir = "$env:USERPROFILE\.hermes-docker",
  [switch]$RemoveFiles,
  [switch]$RemoveData
)
$ErrorActionPreference = 'Stop'
if (-not (Test-Path $InstallDir)) { Write-Host "Hermes Docker install directory not found: $InstallDir"; exit 0 }
Set-Location $InstallDir
if ($RemoveData) { docker compose down -v --remove-orphans } else { docker compose down --remove-orphans }
if ($RemoveFiles) {
  Set-Location $env:USERPROFILE
  Remove-Item -Recurse -Force $InstallDir
  Write-Host "Removed install directory: $InstallDir"
} else {
  Write-Host 'Stopped Hermes Docker stack. Data kept.'
  Write-Host "Remove data too: .\uninstall.ps1 -RemoveData"
  Write-Host "Remove files too: .\uninstall.ps1 -RemoveFiles"
}
