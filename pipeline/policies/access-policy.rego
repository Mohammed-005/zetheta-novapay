package novapay.access

import rego.v1

deny contains "Peer review is required" if {
    input.peer_reviewed != true
}

deny contains "Segregation of duties is required" if {
    input.segregation_of_duties != true
}
