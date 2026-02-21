# Spacelift Clean-Room Trial Boilerplate (GitHub)

This is a **starter** set of repos that mirrors your team's repo layout but is designed for a personal Spacelift trial.
It is intentionally minimal and uses placeholders.

## What you will prove
- **Repave**: bootstrap -> admin-stacks -> platform layout + policies (idempotent)
- **Onboard**: stamp a demo customer dev/test/prod stack set via a blueprint (optional)

## One-time manual setup in Spacelift (expected)
1. Create a **GitHub VCS integration** in Spacelift (UI).
2. Create **one root stack** that points at `sl-root-bootstrap`.
3. Add required env vars/secrets to that stack:
   - `SPACELIFT_API_KEY_ID`
   - `SPACELIFT_API_KEY_SECRET`
   - `GITHUB_TOKEN` (if you want the scaffold/stamping option)

> Notes:
> - This boilerplate assumes the Spacelift Terraform provider is authenticated with API Key ID/Secret.
> - Exact UI labels can vary by Spacelift version; use the "Integrations" section in UI.

## Execution order
1. Run `sl-root-bootstrap` stack (creates admin space + `admin-stacks` stack).
2. Run `admin-stacks` stack (creates:
   - platform spaces
   - module spaces
   - baseline policies + attachments (inherited)
   - demo customer spaces/stacks (optional: if you enable it)
)

## Replace placeholders
Search for `__FILL_ME__` across repos.

