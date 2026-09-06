# NovaPay Environment Promotion Strategy

## 1. Promotion Flow

NovaPay uses a controlled four-environment promotion model:

DEV → STAGING → PRE-PROD → PRODUCTION

Each environment has progressively stricter quality, security, compliance, and approval gates.

## 2. Environment Responsibilities

| Environment | Purpose | Deployment Control |
|---|---|---|
| DEV | Developer integration and rapid feedback | Automatic |
| STAGING | Functional, integration and security validation | Automatic after DEV gates |
| PRE-PROD | Production-like validation and release candidate verification | Approval required |
| PRODUCTION | Live customer workload | Dual approval required |

## 3. DEV

### Entry

A developer pushes a change to the source repository.

### Automated Controls

- Application build
- Unit tests
- SAST
- Dependency scanning
- Container build
- Container vulnerability scanning
- SBOM generation

### Promotion Criteria

DEV promotion succeeds when:

- Build succeeds
- Tests pass
- No blocking SAST findings exist
- Critical container vulnerabilities = 0

Failed gates stop promotion.

## 4. STAGING

STAGING validates the application in an environment representative of the deployment architecture.

### Gates

- Integration tests
- Contract tests
- DAST
- Kubernetes deployment verification
- Health checks
- OPA compliance evaluation

### Promotion Criteria

STAGING → PRE-PROD requires:

- All automated tests pass
- DAST gate passes
- Compliance policy evaluates to true
- Deployment health checks pass
- No critical security vulnerabilities

## 5. PRE-PROD

PRE-PROD is the final production-like validation environment.

### Validation

- Release candidate verification
- Database migration validation
- Blue-green deployment validation
- Canary validation
- Rollback verification
- Performance baseline comparison
- Observability verification

### Approval

A release cannot enter production without an explicit PRE-PROD approval.

The approval provides segregation of duties between development and production deployment responsibilities.

## 6. PRODUCTION

Production deployment uses progressive release controls.

### Deployment Sequence

1. Verify release candidate
2. Confirm compliance gates
3. Confirm database compatibility
4. Deploy inactive Blue/Green environment
5. Run health checks
6. Route controlled Canary traffic
7. Monitor release metrics
8. Promote traffic
9. Run post-deployment verification
10. Mark release stable

## 7. Production Promotion Gates

Production promotion requires:

- Critical vulnerabilities = 0
- OPA compliance result = true
- Required peer review completed
- Segregation of duties satisfied
- Audit logging enabled
- Image signing gate passed
- Health checks successful
- Database migration compatibility confirmed
- Rollback mechanism verified

## 8. Approval Model

Production changes use separation of responsibilities:

Developer
    |
    v
Automated CI gates
    |
    v
Reviewer approval
    |
    v
PRE-PROD validation
    |
    v
Operations/Release approval
    |
    v
Production

The developer who authors a change should not be the sole approver of its production deployment.

## 9. Configuration Hierarchy

Configuration follows environment-specific separation:

DEV
  ↓
STAGING
  ↓
PRE-PROD
  ↓
PRODUCTION

Non-sensitive configuration is managed separately from application code.

Sensitive values such as credentials, tokens and database secrets must be supplied through secret-management mechanisms and must never be committed to Git.

## 10. Data Handling

Production financial/customer data must not be copied directly into lower environments.

Lower environments should use:

- Synthetic data
- Sanitised test data
- Non-production credentials
- Environment-specific databases

Production credentials and secrets remain isolated from development and staging environments.

## 11. Rollback

Every production release must have a verified rollback path.

Immediate rollback conditions include:

- HTTP 5xx rate > 5% for 60 seconds
- Three consecutive health-check failures
- OOM kills
- CrashLoopBackOff
- Database connection pool exhaustion

Escalated rollback conditions include:

- p99 latency > 2× baseline for 5 minutes
- Error-budget burn > 10× normal for 10 minutes
- Transaction success rate > 2% below baseline
- CPU > 90% or memory > 85% for 5 minutes

## 12. Audit Evidence

Each promotion should produce an auditable record containing:

- Commit SHA
- Build/run ID
- Container image tag
- SBOM
- Security scan results
- OPA compliance result
- Reviewer/approver information
- Deployment timestamp
- Environment
- Rollback result if applicable

## 13. Emergency Changes

Emergency production changes still require:

1. Documented reason
2. Security/compliance evaluation where applicable
3. Independent approval
4. Deployment evidence
5. Post-change review

Emergency access must not become a permanent bypass around the normal CI/CD controls.

## 14. Design Goal

The promotion model provides controlled movement from rapid developer feedback to production while maintaining security, compliance, segregation of duties, auditability and rollback capability.
