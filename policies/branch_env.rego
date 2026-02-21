package spacelift
import rego.v1

# --- ENVIRONMENT GUARD POLICY (Label Triggered) ---

governance_label := "governance:env-guard"

deny[msg] if {
    input.stack.labels[governance_label] # Only trigger if label exists
    input.run.type == "APPLY"
    env := input.stack.labels.environment
    branch := input.vcs.branch
    not branch_matches_env(branch, env)
    msg := sprintf("Apply blocked: branch %v does not match env %v", [branch, env])
}

branch_matches_env(branch, env) if {
    env == "dev"
    branch == "dev"
}

branch_matches_env(branch, env) if {
    env == "test"
    branch == "test"
}

branch_matches_env(branch, env) if {
    env == "prod"
    branch == "main"
}

branch_matches_env(branch, env) if {
    env == "live"
    branch == "main"
}
