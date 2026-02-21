package spacelift.env
import rego.v1

# Test: Approval required for Tier 1 Orchestrator
test_approve_tier_1 if {
    approve with input as {
        "stack": {
            "labels": {
                "assurance": ["tier-1"]
            }
        }
    }
}

# Test: Approval required for Tier 2 Critical Workload
test_approve_tier_2 if {
    approve with input as {
        "stack": {
            "labels": {
                "assurance": ["tier-2"],
                "stack-type": ["management"]
            }
        }
    }
}

# Test: Approval NOT required for Standard Tier 3+ Workload
test_no_approve_tier_3 if {
    not approve with input as {
        "stack": {
            "labels": {
                "assurance": ["tier-3"]
            }
        }
    }
}
