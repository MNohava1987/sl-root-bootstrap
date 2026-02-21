package spacelift
import rego.v1

# --- HIGH ASSURANCE APPROVAL POLICY ---

# 1. Tiered Assurance Guards
# Require explicit approval for Tier 0 (Bootstrap) and Tier 1 (Orchestrators)
approve if {
    some tier in input.stack.labels.assurance
    tier == "tier-0"
}

approve if {
    some tier in input.stack.labels.assurance
    tier == "tier-1"
}

# 2. Environment-Specific Safeguards
# Require approval for any stack marked as 'management' in high-assurance tiers (Tier 2+).
approve if {
    some type in input.stack.labels["stack-type"]
    type == "management"
    
    some tier in input.stack.labels.assurance
    tier == "tier-2"
}
