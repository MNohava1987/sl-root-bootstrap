package spacelift
import rego.v1

# Test: Management stack MUST use main for Tracked Run
test_track_management_main if {
    track with input as {
        "stack": {
            "labels": {
                "stack-type": ["management"]
            }
        },
        "push": {
            "branch": "main"
        }
    }
}

# Test: Management stack DOES NOT track on develop
test_no_track_management_develop if {
    not track with input as {
        "stack": {
            "labels": {
                "stack-type": ["management"]
            }
        },
        "push": {
            "branch": "develop"
        }
    }
}

# Test: Management stack triggers PROPOSE on develop
test_propose_management_develop if {
    propose with input as {
        "stack": {
            "labels": {
                "stack-type": ["management"]
            }
        },
        "push": {
            "branch": "develop"
        }
    }
}

# Test: Non-management stack can track on any branch
test_track_standard_any_branch if {
    track with input as {
        "stack": {
            "labels": {
                "stack-type": ["workload"]
            }
        },
        "push": {
            "branch": "feature-branch"
        }
    }
}
