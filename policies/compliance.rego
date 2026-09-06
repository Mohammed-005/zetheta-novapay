package novapay.compliance

import rego.v1

compliance_pass if {
	input.image_signed == true
	input.critical_vulnerabilities == 0
	input.tls_enabled == true
	input.peer_reviewed == true
	input.segregation_of_duties == true
	input.audit_logging == true
}

deny contains "Image must be signed" if {
	input.image_signed != true
}

deny contains "Critical vulnerabilities must be zero" if {
	input.critical_vulnerabilities != 0
}

deny contains "TLS must be enabled" if {
	input.tls_enabled != true
}

deny contains "Peer review is required" if {
	input.peer_reviewed != true
}

deny contains "Segregation of duties is required" if {
	input.segregation_of_duties != true
}

deny contains "Audit logging must be enabled" if {
	input.audit_logging != true
}
