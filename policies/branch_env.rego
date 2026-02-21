package spacelift
import rego.v1

# --- ENVIRONMENT GUARD POLICY (Label Triggered) ---

governance_label := "governance:env-guard"

deny contains msg if {
    input.stack.labels[governance_label] # Only trigger if label exists
    input.run.type == "APPLY"
    branch := input.vcs.branch
    not is_branch_compliant(branch, input.stack.labels)
    msg := sprintf("Apply blocked: branch %v does not match assurance tier for this stack", [branch])
}

# Helper to map branches to assurance tiers
is_branch_compliant(branch, labels) if {
    labels["assurance:tier-2"]
    branch == "main"
}

is_branch_compliant(branch, labels) if {
    not labels["assurance:tier-2"]
    branch == "test" # Allow non-tier-2 to use test branch
}
