package spacelift
import rego.v1

# --- HIGH ASSURANCE APPROVAL POLICY ---

# Require explicit approval for Tier 0 (Bootstrap) and Tier 1 (Orchestrators)
approve if {
    input.stack.labels["assurance:tier-0"]
}

approve if {
    input.stack.labels["assurance:tier-1"]
}

# Require approval for any stack marked as 'management' in the 'live' space
approve if {
    input.stack.labels["stack-type:management"]
    input.stack.labels["environment:live"]
}
