#!/bin/bash

# Spacelift "The Nuclear Option" Script
# Refined for High Assurance Resilience

set -e

# --- CONFIGURATION ---
SPACECTL_PATH="../spacectl"

echo "☢️  Starting Full Wipe..."

# 1. Tier 2: Management Stacks
TARGETS=(
  "admin-platformspaces" 
  "admin-modulespaces" 
  "admin-policies" 
  "admin-modulestacks"
  "sandbox-admin-stacks"
)

for STACK in "${TARGETS[@]}"; do
    echo "🗑️  Deleting $STACK..."
    $SPACECTL_PATH stack delete --id "$STACK" --skip-confirmation || echo "⚠️  $STACK already gone or skip."
done

# 2. Tier 1: Orchestrator
echo "🗑️  Deleting admin-stacks..."
$SPACECTL_PATH stack delete --id "admin-stacks" --skip-confirmation || echo "⚠️  admin-stacks already gone."

# 3. Tier 0: Bootstrap
echo "🗑️  Deleting sl-root-bootstrap..."
$SPACECTL_PATH stack delete --id "sl-root-bootstrap" --skip-confirmation || echo "⚠️  sl-root-bootstrap already gone."

echo "✅ Account wipe initiated!"
