# Spacelift CLI Operations

This guide provides instructions for managing the high-assurance bootstrap process using the spacectl CLI.

## Authentication

All CLI operations require valid API credentials. Ensure the following environment variables are set:

```bash
export SPACELIFT_API_KEY_ENDPOINT="https://your-account.spacelift.io"
export SPACELIFT_API_KEY_ID="01K..."
export SPACELIFT_API_KEY_SECRET="..."
```

## Local Preview (Validation)

Before committing changes to the management plane, you can run a local preview to verify the Terraform plan against the real Spacelift API without triggering a full run.

1. Navigate to the root of the sl-root-bootstrap repository.
2. Run the preview:
   `spacectl stack local-preview --id sl-root-bootstrap`

## Triggering Runs

To trigger an automated run of the bootstrap process after merging changes to main:

`spacectl stack deploy --id sl-root-bootstrap`

## Keyless Governance

Note that once the bootstrap stack is established via the seed, it no longer requires manual API key injection. It utilizes its assigned Space Admin RBAC role and the temporary SPACELIFT_API_TOKEN provided at runtime to manage the account hierarchy.
