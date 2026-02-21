package spacelift
import rego.v1

# --- HIGH ASSURANCE ENVIRONMENT APPROVAL POLICY ---
# This policy governs orchestrators (Tier 1) and workloads (Tier 2).

# Require explicit approval for Tier 1 Orchestrators
approve if {
    some tier in input.stack.labels.assurance
    tier == "tier-1"
}

# Require approval for Tier 2 Critical Workloads (Production/Live)
approve if {
    some tier in input.stack.labels.assurance
    tier == "tier-2"
}
