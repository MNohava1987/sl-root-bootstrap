#!/bin/bash

# Spacelift Post-Creation Automation Script
# Use this immediately after creating the 'sl-root-bootstrap' stack shell in the UI.

set -e

# --- REQUIRED CONFIGURATION ---
# Ensure these are set in your environment
# export SPACELIFT_API_KEY_ENDPOINT="https://..."
# export SPACELIFT_API_KEY_ID="..."
# export SPACELIFT_API_KEY_SECRET="..."
# export VCS_ID="..." # Your GitHub Integration ID/Slug

STACK_ID="sl-root-bootstrap"

echo "Automating Configuration for $STACK_ID..."

# 1. Inject Variables (This ensures no typos and handles secrets securely)
echo " Injecting Environment Variables..."

# Public Variables
../../spacectl stack environment setvar --id "$STACK_ID" TF_VAR_vcs_integration_id "$VCS_ID"
../../spacectl stack environment setvar --id "$STACK_ID" TF_VAR_admin_space_id "root"

# Secret Variables (Write-only)
../../spacectl stack environment setvar --id "$STACK_ID" --write-only TF_VAR_spacelift_api_key_id "$SPACELIFT_API_KEY_ID"
../../spacectl stack environment setvar --id "$STACK_ID" --write-only TF_VAR_spacelift_api_key_secret "$SPACELIFT_API_KEY_SECRET"

# 2. Trigger the Deploy
echo " Triggering the Seed Run..."
../../spacectl stack deploy --id "$STACK_ID"

echo " Automation Complete!"
echo " Monitor the run here: ${SPACELIFT_API_KEY_ENDPOINT}/stack/$STACK_ID"
