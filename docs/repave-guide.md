# Spacelift High-Assurance Repave Guide (RBAC Only)

This guide details how to rebuild your Spacelift management plane using the modern, non-deprecated Role-Based Access Control (RBAC) system.

## Phase 1: One-Time Account Setup
1. **Enable Space RBAC**: Go to `Settings -> Account` and ensure Space-level RBAC is enabled.
2. **GitHub Integration**: `Settings -> Integrations -> GitHub` -> Install App.
3. **API Key**: `Settings -> API Keys` -> Create **Admin** key.

## Phase 2: The "Seed" Identity (Manual UI)
Establish the foundation without using deprecated toggles.
1. **Create Stack**:
   - **Name**: `sl-root-bootstrap`
   - **Space**: `root`
   - **Repo**: `sl-root-bootstrap`
   - **Branch**: `main`
2. **Grant RBAC Role**:
   - Go to **Spaces** -> select **root**.
   - Click **Access** (or **Manage Access**).
   - **Add Access**: Actor: **Stack** (`sl-root-bootstrap`) | Role: **Space Admin**.
   - *Note: Do NOT enable the "Administrative" toggle in Behavior settings.*

## Phase 3: Automated Configuration (The "Repave" Script)
Run the script to inject variables and trigger the build.

```bash
export VCS_ID="your-vcs-id"
cd sl-root-bootstrap
./scripts/repave.sh
```

## Phase 4: Verification
1. Monitor the `sl-root-bootstrap` run.
2. Verify the `Prod` container and `Prod/Admin` space exist.
3. Verify the `admin-stacks` orchestrator has been created inside `Prod/Admin`.
