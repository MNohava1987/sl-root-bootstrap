package spacelift
import rego.v1

# --- TIER 0 (ROOT) GIT FLOW POLICY ---
# This policy only governs the foundational bootstrap identity.

# 1. Tracked Runs (Plan & Apply)
# Only allow apply from main for the bootstrap stack.
track if {
    is_tier_0_stack
    input.push.branch == "main"
}

# 2. Proposed Runs (Previews)
propose if {
    is_tier_0_stack
    input.push.branch != "main"
}

# Helper: Check if the stack is Tier 0
is_tier_0_stack if {
    some tier in input.stack.labels.assurance
    tier == "tier-0"
}
