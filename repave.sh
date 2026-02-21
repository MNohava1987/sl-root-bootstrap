#!/bin/bash

# Spacelift "Repave" Script
# Use this to rebuild the management plane after repos are already established.

set -e

# --- REQUIRED CONFIGURATION ---
# These must be set in your terminal environment before running
# export SPACELIFT_API_KEY_ENDPOINT="https://..."
# export SPACELIFT_API_KEY_ID="..."
# export SPACELIFT_API_KEY_SECRET="..."
# export VCS_ID="..." # Your GitHub Integration UUID

if [ -z "$VCS_ID" ]; then
    echo "❌ Error: VCS_ID environment variable is not set."
    exit 1
fi

STACK_ID="sl-root-bootstrap"

echo "🔄 Starting Spacelift Repave..."

# 1. Cleanup: Delete existing bootstrap stack if it exists
echo "🗑️  Checking for existing stack..."
if ./spacectl stack show --id "$STACK_ID" > /dev/null 2>&1; then
    echo "⚠️  Found existing stack. Deleting..."
    ./spacectl stack delete --id "$STACK_ID" --force
fi

# 2. Recreate the Bootstrap Stack
echo "🏗️  Recreating sl-root-bootstrap stack..."
./spacectl stack create 
  --id "$STACK_ID" 
  --name "$STACK_ID" 
  --space "root" 
  --repository "sl-root-bootstrap" 
  --branch "main" 
  --vendor "terraform" 
  --administrative true

# 3. Inject Required Environment Variables (TF_VARs)
echo "🔑 Injecting configuration..."
./spacectl stack environment setvar --id "$STACK_ID" TF_VAR_vcs_integration_id "$VCS_ID"
./spacectl stack environment setvar --id "$STACK_ID" --write-only TF_VAR_spacelift_api_key_id "$SPACELIFT_API_KEY_ID"
./spacectl stack environment setvar --id "$STACK_ID" --write-only TF_VAR_spacelift_api_key_secret "$SPACELIFT_API_KEY_SECRET"
./spacectl stack environment setvar --id "$STACK_ID" TF_VAR_admin_space_id "root"

# 4. Trigger the Seed Deploy
echo "⚡ Triggering initial deployment..."
./spacectl stack deploy --id "$STACK_ID"

echo "✅ Repave initiated! Monitor the run at: ${SPACELIFT_API_KEY_ENDPOINT}/stack/$STACK_ID"
