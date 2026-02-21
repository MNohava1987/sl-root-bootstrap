# Spacelift CLI Bootstrapping Guide

This document explains how to automate the initial "Seed" stack creation using `spacectl` instead of the Spacelift UI.

## 1. Prerequisites
- `spacectl` installed locally.
- A Spacelift API Key with **Admin** permissions.
- Your GitHub VCS Integration ID (found in Settings -> Integrations).

## 2. Environment Setup
Set your credentials in your terminal session:
```bash
export SPACELIFT_API_KEY_ENDPOINT="https://your-account.spacelift.io"
export SPACELIFT_API_KEY_ID="01K..."
export SPACELIFT_API_KEY_SECRET="..."
```

## 3. The "One-Command" Bootstrap
Run this command to create the `sl-root-bootstrap` stack. This replaces all the manual "Create Stack" steps in the UI.

```bash
spacectl stack create 
  --id "sl-root-bootstrap" 
  --name "sl-root-bootstrap" 
  --space "root" 
  --repository "sl-root-bootstrap" 
  --branch "main" 
  --vendor "terraform" 
  --administrative true
```

*Note: The `--administrative true` flag is critical. It allows this stack to manage other Spacelift resources.*

## 4. Injecting Required Variables
Batch-upload the required Terraform variables as environment variables:

```bash
# GitHub Integration ID
spacectl stack environment setvar --id sl-root-bootstrap TF_VAR_vcs_integration_id "your-vcs-id-here"

# Spacelift API Credentials (for the provider to talk back to Spacelift)
spacectl stack environment setvar --id sl-root-bootstrap --write-only TF_VAR_spacelift_api_key_id "$SPACELIFT_API_KEY_ID"
spacectl stack environment setvar --id sl-root-bootstrap --write-only TF_VAR_spacelift_api_key_secret "$SPACELIFT_API_KEY_SECRET"

# Parent Space ID
spacectl stack environment setvar --id sl-root-bootstrap TF_VAR_admin_space_id "root"
```

## 5. Triggering the First Run
Once the stack and variables are set, trigger the "Seed" run:

```bash
spacectl stack deploy --id sl-root-bootstrap
```

## 6. Architecture Note
After this run succeeds, you will have:
1. An **Admin Space** (isolated from `root`).
2. An **admin-stacks** Stack (sitting in the `Admin` space).

Future infrastructure changes should now happen through the `admin-stacks` orchestrator, keeping your `root` space clean and reserved for high-level governance.
