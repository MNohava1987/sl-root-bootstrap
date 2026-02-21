package spacelift
import rego.v1

# --- HIGH ASSURANCE APPROVAL POLICY ---

# 1. Tiered Assurance Guards
# Require explicit approval for Tier 0 (Bootstrap) and Tier 1 (Orchestrators)
approve if {
    input.stack.labels["assurance:tier-0"]
}

approve if {
    input.stack.labels["assurance:tier-1"]
}

# 2. Environment-Specific Safeguards
# Require approval for any stack marked as 'management' in high-assurance tiers (Tier 2+).
approve if {
    input.stack.labels["stack-type:management"]
    input.stack.labels["assurance:tier-2"]
}
