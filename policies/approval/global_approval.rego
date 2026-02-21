package spacelift
import rego.v1

# --- GLOBAL APPROVAL POLICY (Rego v1) ---

# 1. Require Approval for Administrative Stacks
approve if input.stack.administrative == true

# 2. Require Approval for Production Environments
approve if input.stack.labels["environment"] == "prod"

# 3. Default: Require at least 1 approval for everything in the root space
approve if input.stack.space.id == "root"
