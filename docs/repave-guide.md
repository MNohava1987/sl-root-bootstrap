# Spacelift Repave & Bootstrap Guide

This guide details how to rebuild your Spacelift management plane from scratch.

## Phase 1: One-Time Setup (Manual)
1. **GitHub Integration**: Go to `Settings -> Integrations -> GitHub` and install the Spacelift App.
2. **VCS ID**: Copy the ID of the integration (e.g., `sl-github-vcs-integration`).
3. **API Key**: Go to `Settings -> API Keys` and create an **Admin** key.

## Phase 2: Resetting the Environment (The "Destroy")
1. **Delete the Admin Space**: In the UI, go to `Spaces`, select `Admin`, and delete it.
2. **Delete the Bootstrap Stack**: Delete the `sl-root-bootstrap` stack.

## Phase 3: The "Seed" Shell (Manual UI)
1. **Create Stack**:
   - **Name**: `sl-root-bootstrap`
   - **Space**: `root`
   - **Repo**: `sl-root-bootstrap`
   - **Branch**: `main`
2. **Enable Permissions & Previews**:
   - Go to the stack's **Settings -> Behavior** tab.
   - Toggle **Administrative** to **ON**.
   - Toggle **Local Preview** to **ON**.
   - Click **Save**.
   - *Note: If your account shows an "Access" tab on the root space, you should also assign the "Space Admin" role to this stack there.*

## Phase 4: Automated Configuration (The "Repave" Script)
Run the script to inject all variables and trigger the build.

```bash
# Ensure your Spacelift API keys are in your environment
export VCS_ID="your-vcs-id"
cd sl-root-bootstrap
./repave.sh
```

## Phase 5: Verification
1. Monitor the `sl-root-bootstrap` run.
2. Verify the `Admin` space and `admin-stacks` exist.
