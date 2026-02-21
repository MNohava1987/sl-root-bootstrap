package spacelift
import rego.v1

# --- MANAGEMENT PLANE GIT FLOW POLICY ---

# 1. Tracked Runs (Plan & Apply)
# Stacks that manage the platform itself (stack-type:management) MUST use main.
track if {
    input.stack.labels["stack-type:management"]
    input.push.branch == "main"
}

# 2. Bypass for non-management stacks
# Application or experimental stacks can use any branch.
track if {
    not input.stack.labels["stack-type:management"]
}

# 3. Proposed Runs (Previews)
propose if {
    input.stack.labels["stack-type:management"]
    input.push.branch != "main"
}

# 4. Automatic Housekeeping
discard if {
    input.stack.labels["stack-type:management"]
    input.run.state == "QUEUED"
    input.run.type == "TRACKED"
    count(input.in_progress_runs) > 0
}
