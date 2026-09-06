# NovaPay Compliance Gates

This project implements automated compliance gates as engineering controls for the assessment demonstration. It is not a claim of regulatory certification or legal compliance.

## Automated Hard Gates

| Gate | Threshold | Failure Action |
|---|---|---|
| Critical vulnerabilities | 0 | Block deployment and remediate |
| TLS | Enabled | Block deployment |
| Peer review | Required | Block deployment |
| Segregation of duties | Required | Block deployment |
| Audit logging | Enabled | Block deployment |
| Image signing | Required | Block deployment |

## Regulatory Mapping

| Control | RBI | PCI-DSS v4.0 | SoD |
|---|---|---|---|
| Vulnerability management | Security control | Vulnerability management | — |
| TLS | Secure communication | Requirement 4 | — |
| Peer review | Change management | Change control | ✓ |
| Segregation of duties | Governance | Access/change control | ✓ |
| Audit logging | Auditability | Requirement 10 | ✓ |
| Image signing | Supply-chain integrity | Change control | — |

## Remediation

When a gate fails:

1. Identify the failed control.
2. Remediate the issue.
3. Re-run the relevant security or policy check.
4. Retain the resulting evidence.
5. Allow deployment only after the gate passes.

## Exception Workflow

Exceptions must be documented and time-bound.

1. Engineer records the failed control and reason.
2. Security/reviewer evaluates the request.
3. Authorized approver grants or rejects the exception.
4. Exception ID, owner, reason, approval and expiry are recorded.
5. Compensating controls are documented.
6. Expired exceptions require remediation or re-approval.

## Audit Evidence

Each deployment should retain:

- Commit SHA
- Workflow run ID
- Container image digest
- Security scan results
- SBOM
- OPA policy decision
- Reviewer/approver
- Deployment environment
- Rollback decision
- Exception ID, if applicable

## OPA Policy

OPA is a hard blocking policy gate.

Passing input contains:

- 0 critical vulnerabilities
- TLS enabled
- Peer review completed
- Segregation of duties satisfied
- Audit logging enabled
- Image signed

## AI Attribution

AI assistance was used to help draft the initial compliance policy structure and documentation. The project author reviewed and tested the implementation.
