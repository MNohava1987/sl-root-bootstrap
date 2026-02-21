package spacelift

# Minimal illustrative policy:
# - Allow any plan.
# - For apply: require that branch matches env label.
# This is only a sketch; adapt to Spacelift input schema.

deny[msg] {
  input.run.type == "APPLY"
  env := input.stack.labels.environment
  branch := input.vcs.branch
  not branch_matches_env(branch, env)
  msg := sprintf("Apply blocked: branch %v does not match env %v", [branch, env])
}

branch_matches_env(branch, env) {
  env == "dev"
  branch == "dev"
}
branch_matches_env(branch, env) {
  env == "test"
  branch == "test"
}
branch_matches_env(branch, env) {
  env == "prod"
  branch == "main"
}
