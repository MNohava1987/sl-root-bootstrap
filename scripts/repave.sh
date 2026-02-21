#!/bin/bash

# Spacelift Post-Seed Initialization Script
# This script triggers the first run of the bootstrap stack once the seed has been established.

set -e

STACK_ID="sl-root-bootstrap"

echo "Triggering the management plane foundation build..."

# Trigger the deployment
spacectl stack deploy --id "$STACK_ID"

echo "Handoff complete. Cascade initiated."
echo "Monitor the run at your Spacelift account URL for stack: $STACK_ID"
