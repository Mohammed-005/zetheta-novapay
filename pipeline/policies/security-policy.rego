package novapay.security

import rego.v1

deny contains "Privileged containers are not allowed" if {
    input.privileged_container == true
}

deny contains "TLS is required" if {
    input.tls_enabled != true
}
