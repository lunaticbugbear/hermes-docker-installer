#!/usr/bin/env bash
set -Eeuo pipefail
INSTALL_DIR="${1:-${HERMES_DOCKER_HOME:-$HOME/.hermes-docker}}"
REMOVE_FILES="${REMOVE_FILES:-0}"
REMOVE_DATA="${REMOVE_DATA:-0}"

if [[ ! -d "$INSTALL_DIR" ]]; then
  echo "Hermes Docker install directory not found: $INSTALL_DIR"
  exit 0
fi
cd "$INSTALL_DIR"
if docker compose version >/dev/null 2>&1; then DC=(docker compose); elif command -v docker-compose >/dev/null 2>&1; then DC=(docker-compose); else echo "Docker Compose not found; remove $INSTALL_DIR manually if needed"; exit 1; fi

if [[ "$REMOVE_DATA" == "1" ]]; then
  "${DC[@]}" down -v --remove-orphans || true
else
  "${DC[@]}" down --remove-orphans || true
fi

if [[ "$REMOVE_FILES" == "1" ]]; then
  rm -rf "$INSTALL_DIR"
  echo "Removed install directory: $INSTALL_DIR"
else
  echo "Stopped Hermes Docker stack. Data kept."
  echo "To remove data volume too: REMOVE_DATA=1 $0 $INSTALL_DIR"
  echo "To remove files too: REMOVE_FILES=1 $0 $INSTALL_DIR"
fi
