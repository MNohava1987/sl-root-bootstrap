# Spacelift RBAC Bootstrap Guide (Future-Proof)

This guide details how to rebuild your Spacelift management plane using the modern Role-Based Access Control (RBAC) system.

## Phase 1: One-Time Setup (Manual)
1. **GitHub Integration**: `Settings -> Integrations -> GitHub` -> Install App.
2. **VCS ID**: Copy the Integration ID.
3. **API Key**: `Settings -> API Keys` -> Create **Admin** key.

## Phase 2: The "Seed" Stack (Manual)
You must create the first identity manually to establish the trust link.
1. **Create Stack**:
   - **Name**: `sl-root-bootstrap`
   - **Space**: `root`
   - **Repo**: `sl-root-bootstrap`
   - **Branch**: `main`

## Phase 3: Granting Permissions via RBAC (Manual)
Instead of using the deprecated "Administrative" toggle, you now assign a Space Role:
1. Go to **Spaces** in the main navigation.
2. Select the **root** space.
3. Click the **Access** tab.
4. Click **Add Access**.
5. **Actor**: Select **Stack** and choose `sl-root-bootstrap`.
6. **Role**: Select **Space Admin**.
7. Click **Save**.

*Note: The stack now has full power over the root space and all its children via explicit RBAC.*

## Phase 4: Automated Configuration (The "Repave" Script)
Run the script to inject variables and trigger the build.

```bash
export VCS_ID="your-vcs-id"
./repave.sh
```
