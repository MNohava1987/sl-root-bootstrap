# Spacelift High-Assurance Recovery Guide

This guide details how to restore or repave the Spacelift management plane using the high-assurance bootstrap process.

## Architecture Overview

The recovery process follows a Tier 0 -> Tier 1 handoff:
1. Tier 0 (The Founder): The sl-root-bootstrap stack is established locally via the bootstrap-seed.
2. Tier 1 (The Brain): The bootstrap stack autonomously rebuilds the environment containers, policies, and orchestrators.

## Recovery Procedure

### Phase 1: Establish Root of Trust
The foundational identity and root governance must be restored first.

1. Navigate to the seed directory:
   `cd scripts/bootstrap-seed`
2. Follow the instructions in scripts/bootstrap-seed/README.md to run the local Terraform apply.
3. This will recreate the sl-root-bootstrap stack and its Space Admin permissions.

### Phase 2: High-Assurance Build
Once the bootstrap stack exists in the root space, control is handed off to the platform.

1. Trigger a deployment of the sl-root-bootstrap stack via the Spacelift UI or spacectl.
2. The stack will dynamically discover the account configuration and rebuild the multi-environment hierarchy defined in manifests/management-plane.yaml.

### Phase 3: Verification
1. Confirm that the sl-root-bootstrap run has finished successfully.
2. Verify that environment spaces (e.g., Live) carry the correct assurance labels.
3. Verify that the orchestrator stacks (e.g., live-admin-stacks) are active and governed by the local environment policies.
