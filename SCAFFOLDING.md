# Spacelift CLI Scaffolding (RBAC)

This guide shows how to manage your bootstrap stack using `spacectl` and the RBAC permission model.

## 1. Environment Setup
```bash
export SPACELIFT_API_KEY_ENDPOINT="https://your-account.spacelift.io"
export SPACELIFT_API_KEY_ID="01K..."
export SPACELIFT_API_KEY_SECRET="..."
```

## 2. Permissions (RBAC)
To grant permissions via CLI (if your user has the rights), you would typically use the UI as outlined in `REPAVE_GUIDE.md`. However, once `sl-root-bootstrap` is running, it will use its **Space Admin** role to manage the rest of your account.

## 3. Injecting Variables
After creating the stack shell in the UI, run these to finalize the setup:

```bash
# GitHub Integration ID
spacectl stack environment setvar --id sl-root-bootstrap TF_VAR_vcs_integration_id "your-vcs-id-here"

# Spacelift API Credentials
spacectl stack environment setvar --id sl-root-bootstrap --write-only TF_VAR_spacelift_api_key_id "$SPACELIFT_API_KEY_ID"
spacectl stack environment setvar --id sl-root-bootstrap --write-only TF_VAR_spacelift_api_key_secret "$SPACELIFT_API_KEY_SECRET"

# Parent Space ID
spacectl stack environment setvar --id sl-root-bootstrap TF_VAR_admin_space_id "root"
```

## 4. Triggering the Deployment
```bash
spacectl stack deploy --id sl-root-bootstrap
```
