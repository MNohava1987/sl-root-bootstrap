package spacelift
import rego.v1

# --- TIER 0 (ROOT) APPROVAL POLICY ---
# This policy only governs the foundational bootstrap identity.

approve if {
    some tier in input.stack.labels.assurance
    tier == "tier-0"
}
