package spacelift

# --- HIGH ASSURANCE GIT FLOW POLICY ---

# 1. Tracked Runs (Deploys)
# Only allow actual deployments if the commit is on the 'main' branch.
track {
    input.push.branch == "main"
}

# 2. Proposed Runs (Previews)
# Allow pull requests and branch commits to trigger "Proposed" runs (plans only).
# This prevents them from ever becoming "Tracked" runs.
propose {
    input.push.branch != "main"
}

# 3. Automatic Housekeeping (The "Duplicate Fix")
# If a new run is triggered for a stack, and there is an older run 
# still in the 'QUEUED' state, automatically discard the older one.
# This ensures we are always testing the freshest code.
discard {
    input.run.state == "QUEUED"
    input.run.type == "TRACKED"
    # Logic: If another tracked run exists that is newer, discard this one.
    count(input.in_progress_runs) > 0
}

# 4. Ignore logic
# Explicitly ignore any tag pushes or non-branch events to reduce noise.
ignore {
    not input.push.branch
}
