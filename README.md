# NovaPay Zero-Downtime CI/CD Pipeline

## Executive Summary

NovaPay is a reference DevOps and Cloud Engineering implementation for a regulated banking CI/CD scenario. It demonstrates a secure, zero-downtime delivery architecture combining automated testing, security scanning, compliance-as-code, software supply-chain controls, progressive Kubernetes deployments, automated rollback, database migration safety, and operational observability.

The pipeline uses GitHub Actions to build and validate the application through security and compliance gates before deployment. Kubernetes supports blue-green deployment and controlled canary validation, while rollback automation returns traffic to a known-good version when critical health or verification conditions fail. PostgreSQL schema changes follow the expand-migrate-contract pattern so application versions remain compatible during migration.

The implementation includes six compliance controls covering vulnerability management, TLS, peer review, segregation of duties, audit logging, and image signing. OPA provides policy enforcement, while Trivy, Bandit, OWASP ZAP, and Syft provide security and software-supply-chain checks.

This repository is an engineering assessment/reference implementation, not a production banking system or legal/regulatory certification.

## Table of Contents

- [Architecture](#architecture)
- [CI/CD Pipeline](#cicd-pipeline)
- [Security and Compliance Gates](#security-and-compliance-gates)
- [Deployment Strategies](#deployment-strategies)
- [Automated Rollback](#automated-rollback)
- [Zero-Downtime Database Migration](#zero-downtime-database-migration)
- [Environment Promotion](#environment-promotion)
- [Observability](#observability)
- [Validation and Evidence](#validation-and-evidence)
- [Repository Navigation](#repository-navigation)
- [Technology Stack](#technology-stack)
- [AI Attribution](#ai-attribution)

## Architecture

```text
Developer
   |
   v
Git / GitHub
   |
   v
GitHub Actions
   |
   +--> Build & Unit Test
   +--> SAST
   +--> Dependency Scan
   +--> Container Scan
   +--> Integration / Contract Test
   +--> DAST
   +--> OPA Compliance Gate
   +--> SBOM Generation
   +--> Image Signing Gate
   |
   v
Kubernetes
   |
   +--> Blue Deployment
   +--> Green Deployment
   |
   +--> Canary Deployment
   |
   v
Post-Deployment Verification
   |
   +--> Health Checks
   +--> Smoke Tests
   +--> Version Verification
   |
   +--> Automated Rollback
## CI/CD Pipeline

The pipeline implements the required delivery and security controls:

| Stage | Control |
|---|---|
| Source Control | GitHub repository and pull-request workflow |
| Build & Test | Docker build and automated pytest tests |
| SAST | Bandit static security analysis |
| Dependency Scan | Trivy filesystem vulnerability scan |
| Container Scan | Trivy container image scan |
| Integration / Contract | Application health and API verification |
| DAST | OWASP ZAP baseline security scan |
| Compliance | Open Policy Agent policy evaluation |
| SBOM | Syft CycloneDX SBOM generation |
| Image Signing | Cosign signing-control stage |
| Deployment | Kubernetes blue-green and canary strategies |
| Verification | Health, smoke, and deployment checks |

Security and compliance failures are intended to block progression to deployment.

## Security and Compliance Gates

The implementation demonstrates six automated compliance controls:

1. Critical vulnerability threshold
2. TLS enforcement
3. Mandatory peer review
4. Segregation of duties
5. Audit logging
6. Container image signing

OPA policies are located in:

- [policies/compliance.rego](policies/compliance.rego)
- [pipeline/policies/compliance.rego](pipeline/policies/compliance.rego)

Detailed compliance documentation:

- [Compliance Gate Specification](docs/03-compliance-gates/compliance-gates.md)
- [Compliance Overview](docs/compliance.md)

These are engineering mappings for the assessment and should not be interpreted as legal certification.

## Deployment Strategies

### Blue-Green Deployment

Blue and Green versions can run simultaneously.

Production traffic is switched between the versions through the Kubernetes Service selector. The previously active version remains available so traffic can be returned quickly if verification fails.

### Canary Deployment

A separate Canary deployment and Service provide controlled validation of the new version.

For the local reference implementation:

```text
Normal request
      |
      v
Stable deployment

X-Canary: true
      |
      v
Canary deployment
Canary rollout strategy and validation criteria are documented in:

Canary Rollout
Architecture
Automated Rollback

Rollback is divided into three categories:

Category A: Immediate rollback for critical failures such as high HTTP 5xx rate, repeated health failures, OOM conditions, CrashLoopBackOff, or database connection exhaustion.
Category B: Escalated rollback for sustained latency, error-budget burn, transaction degradation, or resource saturation.
Category C: Manual decision for gradual degradation, customer reports, downstream correlation, or retroactive compliance concerns.

Rollback scripts:

rollback.sh
canary-rollback.sh
production-gate.sh

Detailed specification:

Rollback Specification
Zero-Downtime Database Migration

Database changes follow the expand-migrate-contract pattern:

EXPAND
  |
  v
Add backward-compatible schema
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

001_expand.sql
002_migrate.sql
003_contract.sql

The contract phase is forward-only and requires separate approval. Migration impact above the defined latency threshold causes the migration gate to fail.

Detailed documentation:

Database Migration Strategy
Environment Promotion

The target promotion model separates:

Development
    |
    v
Staging
    |
    v
Pre-Production
    |
    v
Production

Promotion criteria, approval controls, RBAC, configuration hierarchy, and environment data handling are documented in:

Environment Promotion
Observability

The observability design covers:

Deployment frequency
Lead time for changes
Change failure rate
Mean time to recovery
Build success rate
Gate pass rates
Security scanner results
Deployment health
Application health
Rollback triggers

Operational documentation:

Observability Overview
Observability and Incident Simulation
Validation and Evidence

Local validation performed for the reference implementation includes:

pytest                  3 passed
Terraform validate      PASS
Terraform fmt           PASS
OPA check               PASS
OPA compliance eval     PASS
Docker health check     PASS
Docker version check    PASS
Blue-green switch       VERIFIED
Blue-green rollback     VERIFIED
Canary routing          VERIFIED
Database migration gate VERIFIED

Evidence is stored under:

Self Assessment
Reflections
Test Results
TRC Presentation
Repository Navigation
Architecture and Design
01 - Pipeline Architecture
02 - Deployment Strategies
03 - Compliance Gates
04 - Database Migration
05 - Environment Promotion
06 - Rollback Specification
07 - Runbook and Incident Response
08 - Observability
Implementation
app/ — Flask reference application
db/ — database migration examples
k8s/ — Kubernetes manifests
helm/ — Helm deployment chart
pipeline/ — assessment pipeline artifacts
policies/ — OPA compliance policies
scripts/ — operational and rollback scripts
terraform/ — infrastructure as code
Evidence
evidence/ — assessment evidence and validation results
dashboards/ — dashboard and mockup artifacts
Technology Stack
Area	Technology
Application	Python Flask
Containerization	Docker
CI/CD	GitHub Actions
Orchestration	Kubernetes
Local Kubernetes	kind
Packaging	Helm
Infrastructure	Terraform
Policy	Open Policy Agent
SAST	Bandit
Vulnerability Scanning	Trivy
DAST	OWASP ZAP
SBOM	Syft
Image Signing Control	Cosign
Database Pattern	PostgreSQL expand-contract
Version Control	Git / GitHub

The assessment target environment specifies Java 21/Spring Boot and PostgreSQL. Flask is used here as a lightweight reference implementation so the DevOps controls can be demonstrated and validated quickly.

AI Attribution

AI assistance was used during development for documentation drafting, CI/CD workflow development, Kubernetes manifests, Rego policy development, troubleshooting, and project structure refinement.

Generated implementation was reviewed, executed, tested, and validated in the development environment.


## Automated Rollback

Rollback is divided into three categories:

- **Category A:** Immediate rollback for critical failures.
- **Category B:** Escalated rollback for sustained latency, error-budget burn, transaction degradation, or resource saturation.
- **Category C:** Manual decision for gradual degradation, customer reports, downstream correlation, or retroactive compliance concerns.

Rollback scripts:

- [rollback.sh](scripts/rollback.sh)
- [canary-rollback.sh](scripts/canary-rollback.sh)
- [production-gate.sh](scripts/production-gate.sh)

Detailed specification:

- [Rollback Specification](docs/06-rollback-specification/rollback-specification.md)


## Zero-Downtime Database Migration

Database changes follow the expand-migrate-contract pattern:

```text
EXPAND
  |
  v
Add backward-compatible schema
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

001_expand.sql
002_migrate.sql
003_contract.sql

The contract phase is forward-only and requires separate approval. Migration impact above the defined latency threshold causes the migration gate to fail.

Detailed documentation:

Database Migration Strategy


## Environment Promotion

The target promotion model separates:

```text
Development
    |
    v
Staging
    |
    v
Pre-Production
    |
    v
Production
Promotion criteria, approval controls, RBAC, configuration hierarchy, and environment data handling are documented in:

Environment Promotion


## Observability

The observability design covers:

- Deployment frequency
- Lead time for changes
- Change failure rate
- Mean time to recovery
- Build success rate
- Gate pass rates
- Security scanner results
- Deployment health
- Application health
- Rollback triggers

Operational documentation:

- [Observability Overview](docs/08-observability/observability-overview.md)
- [Observability and Incident Simulation](docs/08-observability/observability-and-incident-simulation.md)


## Validation and Evidence

Local validation performed for the reference implementation includes:

```text
pytest                  3 passed
Terraform validate      PASS
Terraform fmt           PASS
OPA check               PASS
OPA compliance eval     PASS
Docker health check     PASS
Docker version check    PASS
Blue-green switch       VERIFIED
Blue-green rollback     VERIFIED
Canary routing          VERIFIED
Database migration gate VERIFIED
Evidence is stored under:

Self Assessment
Reflections
Test Results
TRC Presentation


## Repository Navigation

### Architecture and Design

- [01 - Pipeline Architecture](docs/01-pipeline-architecture/architecture.md)
- [02 - Deployment Strategies](docs/02-deployment-strategies/canary-rollout.md)
- [03 - Compliance Gates](docs/03-compliance-gates/compliance-gates.md)
- [04 - Database Migration](docs/04-database-migration/compatibility-matrix.md)
- [05 - Environment Promotion](docs/05-environment-promotion/environment-promotion.md)
- [06 - Rollback Specification](docs/06-rollback-specification/rollback-specification.md)
- [07 - Runbook and Incident Response](docs/07-runbook-playbook/incident-playbook.md)
- [08 - Observability](docs/08-observability/observability-overview.md)

### Implementation

- `app/` — Flask reference application
- `db/` — database migration examples
- `k8s/` — Kubernetes manifests
- `helm/` — Helm deployment chart
- `pipeline/` — assessment pipeline artifacts
- `policies/` — OPA compliance policies
- `scripts/` — operational and rollback scripts
- `terraform/` — infrastructure as code

### Evidence

- `evidence/` — assessment evidence and validation results
- `dashboards/` — dashboard and mockup artifacts

## Technology Stack

| Area | Technology |
|---|---|
| Application | Python Flask |
| Containerization | Docker |
| CI/CD | GitHub Actions |
| Orchestration | Kubernetes |
| Local Kubernetes | kind |
| Packaging | Helm |
| Infrastructure | Terraform |
| Policy | Open Policy Agent |
| SAST | Bandit |
| Vulnerability Scanning | Trivy |
| DAST | OWASP ZAP |
| SBOM | Syft |
| Image Signing Control | Cosign |
| Database Pattern | PostgreSQL expand-contract |
| Version Control | Git / GitHub |

The assessment target specifies Java 21/Spring Boot and PostgreSQL. Flask is used as a lightweight reference implementation for demonstrating the DevOps controls.

## AI Attribution

AI assistance was used for documentation drafting, CI/CD workflow development, Kubernetes manifests, Rego policy development, troubleshooting, and project structure refinement.

Generated implementation was reviewed, executed, tested, and validated in the development environment.
