package spacelift
import rego.v1

# Test: Tier 0 MUST use main for Tracked Run
test_track_tier_0_main if {
    track with input as {
        "stack": {
            "labels": {
                "assurance": ["tier-0"]
            }
        },
        "push": {
            "branch": "main"
        }
    }
}

# Test: Tier 0 triggers PROPOSE on develop
test_propose_tier_0_develop if {
    propose with input as {
        "stack": {
            "labels": {
                "assurance": ["tier-0"]
            }
        },
        "push": {
            "branch": "develop"
        }
    }
}

# Test: Anything NOT Tier 0 is ignored by this policy
test_no_track_tier_1_develop if {
    not track with input as {
        "stack": {
            "labels": {
                "assurance": ["tier-1"]
            }
        },
        "push": {
            "branch": "main"
        }
    }
}
