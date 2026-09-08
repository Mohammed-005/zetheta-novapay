# NovaPay DevOps & Cloud Engineer Assessment — Self-Assessment

## Implementation Summary

This repository demonstrates a reference implementation of a zero-downtime CI/CD
pipeline for the fictional NovaPay banking application.

The implementation includes:

- Automated build and unit testing
- SAST using Bandit
- Dependency and container vulnerability scanning using Trivy
- SBOM generation
- DAST using OWASP ZAP
- OPA-based compliance validation
- Artifact version and Git SHA traceability
- Kubernetes blue-green deployment
- Kubernetes canary routing
- Automated rollback scripts
- Expand-migrate-contract database migration design
- Terraform infrastructure configuration
- Environment promotion documentation
- Observability and incident-response documentation
- Deployment and rollback runbooks
- Assessment errata documentation
- Validation evidence and TRC presentation

## Validation Evidence

The following checks were executed locally:

| Validation | Result |
|---|---|
| Python unit tests | 3 passed |
| OPA policy syntax check | Passed |
| OPA compliance evaluation | `true` |
| Terraform formatting check | Passed |
| Terraform validation | Passed |

Evidence files are stored under `evidence/test-results/`.

## Deployment Strategy

The repository demonstrates both required deployment approaches:

### Blue-Green

The Kubernetes service selector can switch between blue and green application
versions. The rollback script restores the blue version when rollback is required.

### Canary

The repository contains a canary deployment and routing configuration together
with a rollback check.

The local demonstration uses deterministic header-based canary routing. It is
therefore a demonstration of canary traffic separation rather than a claim of
production-grade percentage-based traffic measurement.

## Database Migration

The database migration design follows the expand-migrate-contract approach:

1. Expand the schema while maintaining backward compatibility.
2. Migrate/backfill data.
3. Contract obsolete schema elements only after separate approval.

The contract stage is intentionally separated from the expand/migrate stages.

## Compliance

OPA evaluates six required engineering controls:

- Image signing
- Critical vulnerability threshold
- TLS
- Peer review
- Segregation of duties
- Audit logging

The compliance policy is treated as an engineering control implementation and
not as legal certification of RBI or PCI-DSS compliance.

## Known Scope Limitations

This repository is a reference/demo implementation rather than a live banking
production environment.

In particular:

- The local canary demonstration uses deterministic header routing.
- The database migration check script demonstrates the required threshold but
  does not connect to a production database.
- Production metric thresholds require integration with the observability stack.
- The current image-signing stage validates the Cosign tooling but does not
  perform a real registry-backed signing operation.
- The project uses a Python Flask reference application for implementation speed;
  the assessment's target application stack is Java 21/Spring Boot 3.x.

These limitations are documented rather than represented as completed production
controls.

---

## AI Attribution

AI assistance was used for drafting, structuring, reviewing, and troubleshooting parts of this deliverable. Final technical decisions, validation, testing, and repository implementation were reviewed by the author.
