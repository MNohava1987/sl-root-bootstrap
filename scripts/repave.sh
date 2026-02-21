#!/bin/bash

# Spacelift Post-Seed Automation Script
# Refined for High Assurance Runtime Authentication (No static keys)

set -e

# --- REQUIRED CONFIGURATION ---
# export VCS_ID="sl-github-vcs-integration"

if [ -z "$VCS_ID" ]; then
    echo "❌ Error: VCS_ID environment variable is not set."
    exit 1
fi

STACK_ID="sl-root-bootstrap"

echo "⚙️  Automating Configuration for $STACK_ID..."

# 1. Inject Variables
# We no longer inject API Keys here. The stack uses its Space Admin role and Runtime Token.
echo "🔑 Injecting Environment Variables..."

# Link to GitHub Integration
../spacectl stack environment setvar --id "$STACK_ID" TF_VAR_vcs_integration_id "$VCS_ID"

# Enable Bootstrap Mode (Auto-Deploy)
../spacectl stack environment setvar --id "$STACK_ID" TF_VAR_enable_auto_deploy "true"

# 2. Trigger the Seed Run
echo "🚀 Triggering the foundation build..."
../spacectl stack deploy --id "$STACK_ID"

echo "✅ Cascade initiated!"
echo "🔗 Monitor the run here: https://mnohava1987.app.us.spacelift.io/stack/$STACK_ID"
