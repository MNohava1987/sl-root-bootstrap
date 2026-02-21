package spacelift.seed
import rego.v1

# Test: Approval REQUIRED for Tier 0 Bootstrap
test_approve_tier_0 if {
    approve with input as {
        "stack": {
            "labels": {
                "assurance": ["tier-0"]
            }
        }
    }
}

# Test: Approval NOT required for anything else (Tier 1+)
# The Seed policy ignores these; they are handled by Env policies.
test_no_approve_tier_1 if {
    not approve with input as {
        "stack": {
            "labels": {
                "assurance": ["tier-1"]
            }
        }
    }
}

test_no_approve_tier_2 if {
    not approve with input as {
        "stack": {
            "labels": {
                "assurance": ["tier-2"]
            }
        }
    }
}
