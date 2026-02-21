package spacelift
import rego.v1

# --- HIGH ASSURANCE GIT FLOW POLICY (Label Triggered) ---

# Define the trigger label
governance_label := "governance:global-flow"

# 1. Tracked Runs (Plan & Apply)
# Only enforce main-only deployments if the stack has the governance label.
track if {
    input.stack.labels[governance_label]
    input.push.branch == "main"
}

# 2. Bypass for non-governed stacks
# If the label is missing, allow any branch to deploy (Low Assurance mode).
track if {
    not input.stack.labels[governance_label]
}

# 3. Proposed Runs
propose if {
    input.stack.labels[governance_label]
    input.push.branch != "main"
}

# 4. Automatic Housekeeping
discard if {
    input.stack.labels[governance_label]
    input.run.state == "QUEUED"
    input.run.type == "TRACKED"
    count(input.in_progress_runs) > 0
}
