# Spacelift Repave & Bootstrap Guide

This guide details how to rebuild your Spacelift management plane from scratch.

## Phase 1: One-Time Setup (Manual)
These steps are required only once per Spacelift account.
1. **GitHub Integration**: Go to `Settings -> Integrations -> GitHub` and install the Spacelift App.
2. **VCS ID**: Copy the ID of the integration (e.g., `sl-github-vcs-integration`).
3. **API Key**: Go to `Settings -> API Keys` and create an **Admin** key.

## Phase 2: Resetting the Environment (The "Destroy")
If you are doing a full repave:
1. **Delete the Admin Space**: In the UI, go to `Spaces`, find `Admin`, and delete it. (This cleans up all child stacks).
2. **Delete the Bootstrap Stack**: Delete the `sl-root-bootstrap` stack.

## Phase 3: The "Seed" Shell (Manual)
You must create the very first stack manually to establish the trust link.
1. **Create Stack**:
   - **Name**: `sl-root-bootstrap`
   - **Space**: `root`
   - **Repo**: `sl-root-bootstrap`
   - **Branch**: `main`
2. **Enable Admin Permissions**:
   - Go to the stack's `Settings -> Infrastructure`.
   - Toggle **Administrative** to **ON**.
   - Click **Save**.

## Phase 4: Automated Configuration (The "Repave" Script)
Run the script to inject all variables and trigger the build.

```bash
export VCS_ID="your-vcs-id"
./repave.sh
```

## Phase 5: Verification
1. Monitor the `sl-root-bootstrap` run.
2. Once finished, verify the `Admin` space and `admin-stacks` exist.
