#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "$ROOT_DIR"

if ! command -v opa >/dev/null 2>&1; then
  echo "opa binary is required to run policy tests."
  echo "Install OPA from https://www.openpolicyagent.org/docs/latest/#running-opa"
  exit 1
fi

opa test ./policies -v
