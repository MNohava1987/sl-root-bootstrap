package spacelift

# --- HIGH ASSURANCE GIT FLOW POLICY ---

# 1. Tracked Runs (Plan & Apply)
# Only allow actual deployments if the commit is on the 'main' branch.
track {
    input.push.branch == "main"
}

# 2. Proposed Runs (Plan Only / Previews)
# Trigger a preview plan for any commit to 'develop' or any other non-main branch.
propose {
    input.push.branch != "main"
}

# 3. Pull Request Handling
# Ensure PRs targeting 'main' also trigger Proposed runs for review.
propose {
    input.pull_request.base == "main"
}

# 4. Automatic Housekeeping
# Auto-discard older queued runs if a newer commit arrives.
discard {
    input.run.state == "QUEUED"
    input.run.type == "TRACKED"
    count(input.in_progress_runs) > 0
}

# 5. Noise Reduction
ignore {
    not input.push.branch
    not input.pull_request
}
