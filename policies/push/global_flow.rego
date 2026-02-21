package spacelift
import rego.v1

# --- MANAGEMENT PLANE GIT FLOW POLICY ---

# 1. Tracked Runs (Plan & Apply)
# Stacks that manage the platform itself (stack-type:management) MUST use main.
track if {
    is_management_stack
    input.push.branch == "main"
}

# 2. Bypass for non-management stacks
# Application or experimental stacks can use any branch.
track if {
    not is_management_stack
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

# 4. Automatic Housekeeping
discard if {
    is_management_stack
    input.run.state == "QUEUED"
    input.run.type == "TRACKED"
    count(input.in_progress_runs) > 0
}

# Helper: Check if the stack is a management stack
is_management_stack if {
    some type in input.stack.labels["stack-type"]
    type == "management"
}
