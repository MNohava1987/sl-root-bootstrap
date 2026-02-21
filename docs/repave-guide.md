# Spacelift High-Assurance Repave Guide

This document provides definitive, step-by-step instructions for performing a "Nuke and Pave" operation on the Spacelift management plane. This procedure is designed to restore the organization to a clean, known-good state from a completely empty account.

## Architecture Tiers

- **Tier 0 (Root/Seed)**: The foundational identity and root governance established locally.
- **Tier 1 (Orchestrators)**: Regional management plane stacks created autonomously by Tier 0.
- **Tier 2+ (Workloads)**: Downstream infrastructure managed by Tier 1.

---

## Part 1: The "Nuke" (Complete Deconstruction)

Safety Note: Destruction is protected by variables to prevent accidental execution.

### Step 1: Unlock Environment Protection
1. Open `sl-root-bootstrap/variables.tf`.
2. Set `enable_deletion_protection = false`.
3. Commit and push to `main`.
4. Trigger a run of the `sl-root-bootstrap` stack in Spacelift and confirm the Apply. This "unlocks" all Tier 1 orchestrator stacks.

### Step 2: Clear the Management Plane
1. Open `sl-root-bootstrap/manifests/management-plane.yaml`.
2. Comment out or remove all entries under the `environments:` key.
3. Commit and push to `main`.
4. Trigger a run of the `sl-root-bootstrap` stack. Spacelift will autonomously delete all environment spaces, local policies, and orchestrator stacks.

### Step 3: Unlock and Destroy the Foundation
1. Navigate to `scripts/bootstrap-seed/variables.tf`.
2. Set `enable_deletion_protection = false`.
3. Set sensitive credentials if not already in your environment:
   `export TF_VAR_spacelift_api_key_id="xxx"`
   `export TF_VAR_spacelift_api_key_secret="xxx"`
4. Execute the unlock:
   `terraform apply -auto-approve`
5. Execute the final wipe:
   `terraform destroy -auto-approve`

---

## Part 2: The "Pave" (Complete Restoration)

### Step 1: establish Root of Trust (Tier 0)
Follow the instructions in `scripts/bootstrap-seed/README.md` to run the local seed.
1. Ensure `enable_deletion_protection = true` in `variables.tf`.
2. Run `terraform init` and `terraform apply`.
3. Verification: The `sl-root-bootstrap` stack and root policies will appear in the Spacelift Root space.

### Step 2: Restore the Management Plane (Tier 1)
1. Ensure your environment configurations are active in `manifests/management-plane.yaml`.
2. Ensure `enable_deletion_protection = true` in `sl-root-bootstrap/variables.tf`.
3. Commit and push your changes to the `main` branch.
4. Navigate to the `sl-root-bootstrap` stack in the Spacelift UI.
5. Trigger a **Tracked Run**.
6. Review the plan and click **Confirm**.

### Step 3: Final Verification
1. Confirm the `sl-root-bootstrap` run has status **FINISHED**.
2. Verify that environment spaces (e.g., Live) exist.
3. Verify that environment-specific policies are created inside their respective spaces.
4. Verify that the orchestrator stacks (e.g., `live-admin-stacks`) are active and carry the correct assurance labels.

---

## Operational Safety
Always perform a `local-preview` before Step 2 of the Pave process to ensure the restoration plan is correct without triggering premature changes:
`spacectl stack local-preview --id sl-root-bootstrap`
