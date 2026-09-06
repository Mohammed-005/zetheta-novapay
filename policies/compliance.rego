package novapay

default compliance_pass = false

compliance_pass if {
    input.image_signed == true
    input.critical_vulnerabilities == 0
    input.tls_enabled == true
    input.peer_reviewed == true
    input.segregation_of_duties == true
    input.audit_logging == true
}

deny contains "Unsigned container image" if {
    input.image_signed != true
}

deny contains "Critical vulnerabilities detected" if {
    input.critical_vulnerabilities > 0
}

deny contains "TLS is not enabled" if {
    input.tls_enabled != true
}

deny contains "Peer review requirement failed" if {
    input.peer_reviewed != true
}

deny contains "Segregation of duties requirement failed" if {
    input.segregation_of_duties != true
}

deny contains "Audit logging requirement failed" if {
    input.audit_logging != true
}
