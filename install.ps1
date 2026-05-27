# Hermes Agent Docker Public Installer for Windows PowerShell
# Requires Docker Desktop with WSL2 backend enabled.
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\install.ps1
#   .\install.ps1 -Provider openrouter -Model deepseek/deepseek-v4-flash:free -OpenRouterApiKey sk-...

param(
  [string]$InstallDir = "$env:USERPROFILE\.hermes-docker",
  [ValidateSet('openrouter','anthropic','openai','google','deepseek','custom')]
  [string]$Provider = 'openrouter',
  [string]$Model = 'deepseek/deepseek-v4-flash:free',
  [int]$Port = 8642,
  [string]$ProjectName = 'hermes-agent',
  [switch]$NoStart,
  [switch]$NoBrowser,
  [switch]$SkipBuild,
  [switch]$Force,
  [switch]$Uninstall,
  [string]$OpenRouterApiKey = $env:OPENROUTER_API_KEY,
  [string]$AnthropicApiKey = $env:ANTHROPIC_API_KEY,
  [string]$OpenAIApiKey = $env:OPENAI_API_KEY,
  [string]$GoogleApiKey = $env:GOOGLE_API_KEY,
  [string]$DeepSeekApiKey = $env:DEEPSEEK_API_KEY,
  [string]$CustomApiKey = $env:CUSTOM_API_KEY,
  [string]$CustomBaseUrl = $env:CUSTOM_BASE_URL,
  [string]$ApiServerKey = $env:API_SERVER_KEY
)

$ErrorActionPreference = 'Stop'

function Log($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Ok($msg) { Write-Host "OK: $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "WARN: $msg" -ForegroundColor Yellow }
function Die($msg) { Write-Host "ERROR: $msg" -ForegroundColor Red; exit 1 }
function Test-Command($cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

function ComposeArgs() {
  docker compose version *> $null
  if ($LASTEXITCODE -eq 0) { return @('compose') }
  if (Test-Command 'docker-compose') { return @() }
  Die 'Docker Compose v2 not found. Install Docker Desktop.'
}

function Run-Compose([string[]]$Args) {
  docker compose @Args
}

function New-SecretHex() {
  $bytes = New-Object byte[] 24
  [System.Security.Cryptography.RandomNumberGenerator]::Fill($bytes)
  return (($bytes | ForEach-Object { $_.ToString('x2') }) -join '')
}

function Safe-Write($Path, $Content) {
  if ((Test-Path $Path) -and -not $Force) {
    Warn "Keeping existing $Path. Use -Force to overwrite."
    return
  }
  $parent = Split-Path $Path -Parent
  if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  Set-Content -Path $Path -Value $Content -Encoding UTF8
}

function Test-PortInUse([int]$Port) {
  $conn = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
  return [bool]$conn
}

function Resolve-Port() {
  if (Test-PortInUse $Port) {
    Warn "Port $Port is already in use."
    foreach ($candidate in @(8643,8644,18642,28642)) {
      if (-not (Test-PortInUse $candidate)) {
        $ans = Read-Host "Use free port $candidate instead? [Y/n]"
        if (-not $ans -or $ans -match '^(y|yes)$') { $script:Port = $candidate; Ok "Using port $Port"; return }
      }
    }
    Die "Choose a free port with -Port <port>."
  }
}

function Wait-Health() {
  $url = "http://127.0.0.1:$Port/health"
  Log "Waiting for Hermes API healthcheck: $url"
  for ($i=0; $i -lt 60; $i++) {
    try { Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 3 | Out-Null; Ok 'Hermes API server is healthy'; return } catch { Start-Sleep -Seconds 2 }
  }
  Warn 'Healthcheck did not pass within 120 seconds. Showing recent logs:'
  docker compose logs --tail 80 hermes
}

Log 'Hermes Docker Installer for Windows'

if (-not (Test-Command 'docker')) {
  Die 'Docker not found. Install Docker Desktop: https://docs.docker.com/desktop/install/windows-install/'
}

docker info *> $null
if ($LASTEXITCODE -ne 0) {
  Die 'Docker Desktop is not running or WSL2 backend is disabled. Start Docker Desktop and retry.'
}
Ok 'Docker is ready'

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $InstallDir 'workspace') | Out-Null
Set-Location $InstallDir

if ($Uninstall) {
  Run-Compose @('down')
  $ans = Read-Host 'Remove data volume too? This deletes config/sessions/memory [y/N]'
  if ($ans -match '^(y|yes)$') { Run-Compose @('down','-v') }
  exit 0
}

Resolve-Port

if (-not $PSBoundParameters.ContainsKey('Provider')) {
  Write-Host ''
  Write-Host 'Choose your model provider:'
  Write-Host '  1) OpenRouter  recommended, many models'
  Write-Host '  2) Anthropic'
  Write-Host '  3) OpenAI'
  Write-Host '  4) Google Gemini'
  Write-Host '  5) DeepSeek'
  Write-Host '  6) Custom OpenAI-compatible endpoint'
  $choice = Read-Host 'Provider [1]'
  if (-not $choice) { $choice = '1' }
  switch ($choice) {
    '1' { $Provider='openrouter'; if (-not $PSBoundParameters.ContainsKey('Model')) { $Model='deepseek/deepseek-v4-flash:free' } }
    '2' { $Provider='anthropic'; if (-not $PSBoundParameters.ContainsKey('Model')) { $Model='claude-sonnet-4' } }
    '3' { $Provider='openai'; if (-not $PSBoundParameters.ContainsKey('Model')) { $Model='gpt-4.1' } }
    '4' { $Provider='google'; if (-not $PSBoundParameters.ContainsKey('Model')) { $Model='gemini-2.0-flash' } }
    '5' { $Provider='deepseek'; if (-not $PSBoundParameters.ContainsKey('Model')) { $Model='deepseek-chat' } }
    '6' { $Provider='custom' }
    default { Die "Invalid provider choice: $choice" }
  }
  $modelInput = Read-Host "Model [$Model]"
  if ($modelInput) { $Model = $modelInput }
}

if (-not $ApiServerKey) { $ApiServerKey = New-SecretHex }

$selectedKey = switch ($Provider) {
  'openrouter' { $OpenRouterApiKey }
  'anthropic' { $AnthropicApiKey }
  'openai' { $OpenAIApiKey }
  'google' { $GoogleApiKey }
  'deepseek' { $DeepSeekApiKey }
  'custom' { $CustomApiKey }
}
if (-not $selectedKey) {
  $selectedKey = Read-Host "API key for provider '$Provider' (press Enter to skip)"
}
if (-not $selectedKey) {
  Warn "No API key provided. Hermes will install, but model calls will fail until you edit $InstallDir\.env."
} elseif ($selectedKey.Length -lt 12) {
  Warn "API key looks unusually short. Continuing, but verify it in $InstallDir\.env if model calls fail."
}

$orKey=''; $anthKey=''; $oaKey=''; $gKey=''; $gemKey=''; $dsKey=''; $cKey=''
switch ($Provider) {
  'openrouter' { $orKey=$selectedKey }
  'anthropic' { $anthKey=$selectedKey }
  'openai' { $oaKey=$selectedKey }
  'google' { $gKey=$selectedKey; $gemKey=$selectedKey }
  'deepseek' { $dsKey=$selectedKey }
  'custom' { $cKey=$selectedKey }
}

$installBrowser = if ($NoBrowser) { '0' } else { '1' }

Safe-Write '.env' @"
COMPOSE_PROJECT_NAME=$ProjectName
MODEL_PROVIDER=$Provider
MODEL_NAME=$Model
API_SERVER_PORT=$Port
API_SERVER_KEY=$ApiServerKey
INSTALL_BROWSER=$installBrowser
OPENROUTER_API_KEY=$orKey
ANTHROPIC_API_KEY=$anthKey
OPENAI_API_KEY=$oaKey
GOOGLE_API_KEY=$gKey
GEMINI_API_KEY=$gemKey
DEEPSEEK_API_KEY=$dsKey
CUSTOM_API_KEY=$cKey
CUSTOM_BASE_URL=$CustomBaseUrl
"@

Safe-Write 'Dockerfile' @'
FROM python:3.12-slim-bookworm
ARG INSTALL_BROWSER=1
ENV DEBIAN_FRONTEND=noninteractive \
    HERMES_HOME=/root/.hermes \
    PATH=/root/.hermes/hermes-agent/venv/bin:/root/.local/bin:$PATH \
    PYTHONUNBUFFERED=1
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash ca-certificates curl git build-essential python3 python3-dev python3-pip python3-venv \
    pkg-config tmux cron jq ripgrep fd-find procps less nano openssh-client netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
RUN if [ "$INSTALL_BROWSER" = "1" ]; then \
      /root/.hermes/hermes-agent/venv/bin/python -m pip install --upgrade pip playwright && \
      /root/.hermes/hermes-agent/venv/bin/python -m playwright install --with-deps chromium; \
    fi
COPY bootstrap.sh /usr/local/bin/bootstrap.sh
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/bootstrap.sh /usr/local/bin/healthcheck.sh
WORKDIR /workspace
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 CMD /usr/local/bin/healthcheck.sh
ENTRYPOINT ["/usr/local/bin/bootstrap.sh"]
CMD ["hermes", "gateway", "run"]
'@

Safe-Write 'bootstrap.sh' @'
#!/usr/bin/env bash
set -Eeuo pipefail
export HERMES_HOME="${HERMES_HOME:-/root/.hermes}"
export PATH="/root/.hermes/hermes-agent/venv/bin:/root/.local/bin:$PATH"
mkdir -p "$HERMES_HOME" /workspace "$HERMES_HOME/logs"
MODEL_PROVIDER="${MODEL_PROVIDER:-openrouter}"
MODEL_NAME="${MODEL_NAME:-deepseek/deepseek-v4-flash:free}"
API_SERVER_KEY="${API_SERVER_KEY:-change-me}"
API_SERVER_PORT="${API_SERVER_PORT:-8642}"
CUSTOM_BASE_URL="${CUSTOM_BASE_URL:-}"
cat > "$HERMES_HOME/.env" <<EOENV
OPENROUTER_API_KEY=${OPENROUTER_API_KEY:-}
ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY:-}
OPENAI_API_KEY=${OPENAI_API_KEY:-}
GOOGLE_API_KEY=${GOOGLE_API_KEY:-}
GEMINI_API_KEY=${GEMINI_API_KEY:-}
DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY:-}
CUSTOM_API_KEY=${CUSTOM_API_KEY:-}
API_SERVER_KEY=$API_SERVER_KEY
GATEWAY_ALLOW_ALL_USERS=true
PLAYWRIGHT_BROWSERS_PATH=/root/.cache/ms-playwright
EOENV
chmod 600 "$HERMES_HOME/.env" || true
cat > "$HERMES_HOME/config.yaml" <<EOCFG
model:
  provider: "$MODEL_PROVIDER"
  default: "$MODEL_NAME"
  base_url: "$CUSTOM_BASE_URL"
terminal:
  backend: local
  cwd: /workspace
  timeout: 180
memory:
  memory_enabled: true
  user_profile_enabled: true
approvals:
  mode: manual
platforms:
  api_server:
    enabled: true
    extra:
      host: "0.0.0.0"
      port: $API_SERVER_PORT
      key: "$API_SERVER_KEY"
EOCFG
for tool in terminal file web browser vision skills memory session_search delegation cronjob todo; do hermes tools enable "$tool" >/dev/null 2>&1 || true; done
exec "$@"
'@

Safe-Write 'healthcheck.sh' @'
#!/usr/bin/env bash
set -euo pipefail
PORT="${API_SERVER_PORT:-8642}"
curl -fsS --max-time 5 "http://127.0.0.1:${PORT}/health" >/dev/null || exit 1
'@

Safe-Write 'docker-compose.yml' @'
services:
  hermes:
    build:
      context: .
      args:
        INSTALL_BROWSER: ${INSTALL_BROWSER:-1}
    image: local/hermes-agent:latest
    container_name: hermes-agent
    env_file:
      - .env
    ports:
      - "${API_SERVER_PORT:-8642}:${API_SERVER_PORT:-8642}"
    volumes:
      - hermes_home:/root/.hermes
      - ./workspace:/workspace
    stdin_open: true
    tty: true
    restart: unless-stopped
    command: ["hermes", "gateway", "run"]
volumes:
  hermes_home:
'@

Safe-Write 'hermes-docker.ps1' @'
param([string]$Command='help')
$ErrorActionPreference='Stop'
Set-Location $PSScriptRoot
switch ($Command) {
  'start' { docker compose up -d }
  'stop' { docker compose stop }
  'restart' { docker compose restart }
  'status' { docker compose ps }
  'logs' { docker compose logs -f hermes }
  'cli' { docker compose exec hermes hermes }
  'shell' { docker compose exec hermes bash }
  'build' { docker compose build }
  'update' { docker compose build --pull; docker compose up -d }
  'down' { docker compose down }
  'reset' { docker compose down -v }
  'url' { $envfile=Get-Content .env; ($envfile | ? {$_ -like 'API_SERVER_PORT=*'}) -replace 'API_SERVER_PORT=','' | % { "http://localhost:$_" } }
  'key' { (Get-Content .env | ? {$_ -like 'API_SERVER_KEY=*'}) -replace 'API_SERVER_KEY=','' }
  default { Write-Host 'Commands: start stop restart status logs cli shell build update down reset url key' }
}
'@

Safe-Write 'README.md' @"
# Hermes Agent Docker

Commands:

    .\hermes-docker.ps1 start
    .\hermes-docker.ps1 cli
    .\hermes-docker.ps1 logs
    .\hermes-docker.ps1 status
    .\hermes-docker.ps1 update

API server:

    http://localhost:$Port

Edit config/API keys:

    $InstallDir\.env
"@

if ($SkipBuild) {
  Log 'Generated files only; skipping Docker build/start.'
  docker compose config | Out-Null
  Ok 'Docker Compose config is valid'
} else {
  Log 'Building Docker image. First build can take 5-15 minutes...'
  docker compose build
  if (-not $NoStart) {
    docker compose up -d
    docker compose ps
    Wait-Health
  }
}

Ok 'Hermes Agent Docker is installed.'
Write-Host "Install directory: $InstallDir"
Write-Host "Open CLI: cd '$InstallDir'; .\hermes-docker.ps1 cli"
Write-Host "Logs: cd '$InstallDir'; .\hermes-docker.ps1 logs"
Write-Host "API server: http://localhost:$Port"
