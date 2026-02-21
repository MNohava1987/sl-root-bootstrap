#!/bin/bash

# Spacelift "The Nuclear Option" Script
# This script performs a full, surgical destruction of the management plane
# following the correct dependency order.

set -e

# --- REQUIRED CONFIGURATION ---
# export SPACELIFT_API_KEY_ENDPOINT="https://..."
# export SPACELIFT_API_KEY_ID="..."
# export SPACELIFT_API_KEY_SECRET="..."

echo "☢️  WARNING: Starting Full Destruction of Spacelift Management Plane..."

# 1. Surgical Strike on Tier 2 Stacks (Management Stacks)
# These are the stacks created by the orchestrator.
TIER2_STACKS=("admin-platformspaces" "admin-modulespaces" "admin-policies" "admin-modulestacks")

for STACK in "${TIER2_STACKS[@]}"; do
    if ../spacectl stack show --id "$STACK" > /dev/null 2>&1; then
        echo "🗑️  Destroying Resources and Deleting Stack: $STACK"
        # --destroy-resources triggers a real TF destroy run before deleting the identity
        ../spacectl stack delete --id "$STACK" --destroy-resources --skip-confirmation
    fi
done

# 2. Surgical Strike on Tier 1 (The Orchestrator)
ORCHESTRATOR="admin-stacks"
if ../spacectl stack show --id "$ORCHESTRATOR" > /dev/null 2>&1; then
    echo "🗑️  Destroying Resources and Deleting Orchestrator: $ORCHESTRATOR"
    ../spacectl stack delete --id "$ORCHESTRATOR" --destroy-resources --skip-confirmation
fi

# 3. Final Foundation Cleanup (Bootstrap)
# We don't use --destroy-resources here because the Bootstrap stack manages 
# the Admin space. If we delete the stack first, the space becomes an orphan.
# Instead, we should have run the bootstrap with commented-out code.
# For a TOTAL wipe, we'll just force delete the bootstrap identity now.
BOOTSTRAP="sl-root-bootstrap"
if ../spacectl stack show --id "$BOOTSTRAP" > /dev/null 2>&1; then
    echo "🗑️  Deleting Bootstrap Identity: $BOOTSTRAP"
    ../spacectl stack delete --id "$BOOTSTRAP" --skip-confirmation
fi

echo "✅ Account is now empty. You may need to manually delete the 'Admin' space in the UI if it remains."
