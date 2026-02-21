package spacelift.env
import rego.v1

# --- ENVIRONMENT GIT FLOW POLICY ---
# This policy governs environment management and critical workloads.

# 1. Tracked Runs (Plan & Apply)
# Stacks that manage the platform itself (stack-type:management) MUST use main.
track if {
    is_management_stack
    input.push.branch == "main"
}

# Stacks in Tier 2 (Critical Workloads) MUST use main.
track if {
    is_tier_2_stack
    input.push.branch == "main"
}

# 2. Bypass for non-critical/non-management stacks
track if {
    not is_management_stack
    not is_tier_2_stack
}

# 3. Proposed Runs (Previews)
# This explicitly triggers plans for 'develop' and other non-main branches.
propose if {
    is_management_stack
    input.push.branch == "develop"
}

propose if {
    is_management_stack
    input.push.branch != "main"
    input.push.branch != "develop"
}

# Helper: Check if the stack is a management stack
is_management_stack if {
    some type in input.stack.labels["stack-type"]
    type == "management"
}

# Helper: Check if the stack is Tier 2
is_tier_2_stack if {
    some tier in input.stack.labels.assurance
    tier == "tier-2"
}
