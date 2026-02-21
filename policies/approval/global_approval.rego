package spacelift

# --- GLOBAL APPROVAL POLICY ---

# 1. Require Approval for Administrative Stacks
# Any stack marked as administrative manages Spacelift itself.
# These MUST be peer-reviewed.
approve {
    input.stack.administrative == true
}

# 2. Require Approval for Production Environments
# Any stack with the 'environment:prod' label requires approval.
approve {
    input.stack.labels["environment"] == "prod"
}

# 3. Default: Require at least 1 approval for everything in the root space
# This is the "Constitutional Law" for high assurance.
approve {
    input.stack.space.id == "root"
}

# Sample logic for WHO can approve (Commented out until teams are defined)
# allow_approval {
#     input.user.teams[_] == "Senior Engineers"
# }
