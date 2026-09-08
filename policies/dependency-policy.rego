package novapay.dependencies

import rego.v1

deny contains "Critical vulnerabilities must be zero" if {
    input.critical_vulnerabilities != 0
}

deny contains "SBOM is required" if {
    input.sbom_generated != true
}
