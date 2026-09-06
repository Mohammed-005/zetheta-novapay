# NovaPay Zero-Downtime CI/CD Pipeline

## Overview

NovaPay Digital Bank is a reference DevOps and Cloud Engineering implementation demonstrating a secure zero-downtime CI/CD pipeline.

The project includes automated testing, security scanning, compliance gates, SBOM generation, image-signing controls, Kubernetes deployment strategies, rollback automation, and zero-downtime database migration.

> This is an engineering assessment/reference implementation and is not legal, regulatory, or production banking certification.

## Architecture

Developer
  |
  v
GitHub
  |
  v
GitHub Actions
  |
  +--> Build & Test
  +--> SAST
  +--> Dependency Scan
  +--> Container Scan
  +--> SBOM Generation
  +--> Integration Testing
  +--> DAST
  +--> OPA Compliance Gates
  +--> Image Signing Gate
  |
  v
Kubernetes
  |
  +--> Blue Deployment
  +--> Green Deployment
  +--> Canary Deployment
  |
  v
Production Verification
  |
  +--> Health Checks
  +--> Rollback

## Technology Stack

| Area | Technology |
|---|---|
| Application | Python Flask |
| Containerization | Docker |
| CI/CD | GitHub Actions |
| Policy | Open Policy Agent |
| Security | Bandit, Trivy, OWASP ZAP |
| SBOM | Syft |
| Image Signing | Cosign |
| Orchestration | Kubernetes |
| Local Kubernetes | kind |
| Packaging | Helm |
| Infrastructure | Terraform |
| Database Migration | PostgreSQL expand-contract pattern |
| Version Control | Git/GitHub |

The assessment scenario targets Java 21/Spring Boot and PostgreSQL. This implementation uses Flask as a lightweight reference application to demonstrate the DevOps controls and deployment architecture.

## CI/CD Security Gates

The pipeline includes:

1. Source checkout
2. Application build
3. Automated tests
4. Static application security testing
5. Dependency and container vulnerability scanning
6. SBOM generation
7. Integration testing
8. Dynamic application security testing
9. OPA compliance policy evaluation
10. Image-signing gate
11. Kubernetes deployment verification

Security and compliance failures are designed to block pipeline progression.

## Compliance Controls

The implementation demonstrates automated controls for:

- Critical vulnerability threshold
- TLS enforcement
- Mandatory peer review
- Segregation of duties
- Audit logging
- Container image signing

Detailed compliance evidence and remediation guidance are documented in:

docs/compliance.md

These are engineering mappings for the assessment and should not be interpreted as legal certification.

## Zero-Downtime Deployment

### Blue-Green

Blue and Green application versions can run simultaneously.

Production traffic can be switched between versions using the Kubernetes Service selector.

Rollback returns production traffic to the known-good Blue deployment.

### Canary

A separate Canary deployment and Service are used for controlled validation.

Canary traffic can be routed using:

X-Canary: true

Normal requests use the stable deployment.

Canary requests are routed to the Canary deployment.

## Automated Rollback

Rollback automation verifies:

- Deployment readiness
- Pod health
- Application health endpoint
- Canary endpoint availability

If critical verification fails, production traffic is returned to Blue.

Scripts:

- scripts/rollback.sh
- scripts/canary-rollback.sh
- scripts/production-gate.sh

## Zero-Downtime Database Migration

The database migration follows the expand-contract pattern:

EXPAND
  |
  v
Add compatible schema
  |
  v
MIGRATE
  |
  v
Backfill / transition data
  |
  v
CONTRACT
  |
  v
Remove legacy schema

Migration files:

- db/migrations/001_expand.sql
- db/migrations/002_migrate.sql
- db/migrations/003_contract.sql

The contract phase requires explicit approval before destructive schema changes.

## Validation

OPA:

opa check policies/compliance.rego

opa eval --data policies/compliance.rego --input policies/input.json "data.novapay.compliance.compliance_pass"

Expected result:

true

Terraform:

terraform fmt -recursive
terraform validate

Production verification:

./scripts/production-gate.sh

## Repository Structure

.
├── .github/
│   └── workflows/
│       └── ci.yml
├── app/
├── db/
│   └── migrations/
├── docs/
│   └── compliance.md
├── k8s/
├── policies/
├── scripts/
├── terraform/
├── Dockerfile
├── README.md
└── requirements.txt

## AI Attribution

AI assistance was used during development for documentation drafting, CI/CD workflow development, Kubernetes manifests, Rego policy development, troubleshooting, and project structure refinement.

Generated implementation was reviewed, executed, and validated in the development environment.
