#!/bin/bash

# Spacelift De-provisioning Script
# This script removes the management plane resources.

set -e

# Configuration
SPACECTL_PATH="spacectl"

echo "Starting management plane removal..."

# 1. Tier 1: Orchestrators
# Note: Add specific environment orchestrators here as needed
TARGETS=(
  "live-admin-stacks"
  "matt-test1-admin-stacks"
)

for STACK in "${TARGETS[@]}"; do
    echo "Deleting $STACK..."
    $SPACECTL_PATH stack delete --id "$STACK" --skip-confirmation || echo "$STACK already removed or skip."
done

# 2. Tier 0: Bootstrap
echo "Deleting sl-root-bootstrap..."
$SPACECTL_PATH stack delete --id "sl-root-bootstrap" --skip-confirmation || echo "sl-root-bootstrap already removed."

echo "Removal process completed."
