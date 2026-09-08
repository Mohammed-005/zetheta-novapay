# NovaPay Rollback Specification

## 1. Purpose

This document defines rollback categories, automated triggers, verification steps, and manual escalation for the NovaPay zero-downtime deployment pipeline.

The local implementation is a reference/demo environment. Production banking deployments require integration with Prometheus, OpenTelemetry, Kubernetes health signals, database telemetry, and deployment tooling.

---

## 2. Rollback Categories

### Category A — Immediate Automated Rollback

Rollback immediately when any critical deployment failure is detected:

| Trigger | Threshold | Action |
|---|---:|---|
| HTTP 5xx error rate | >5% for 60 seconds | Immediate rollback |
| Health checks | 3 consecutive failures | Immediate rollback |
| Out-of-memory | OOMKilled | Immediate rollback |
| Kubernetes crash state | CrashLoopBackOff | Immediate rollback |
| Database connection pool | Pool exhaustion | Immediate rollback |

These conditions indicate a high-confidence production failure and do not require manual approval.

---

### Category B — Automated Rollback

Rollback when sustained degradation exceeds the defined production thresholds:

| Trigger | Threshold | Action |
|---|---:|---|
| p99 latency | >2x rolling 7-day baseline for 5 minutes | Rollback |
| Error-budget burn | >10x for 10 minutes | Rollback |
| Transaction success rate | Decrease >2% from baseline | Rollback |
| CPU utilization | >90% for 5 minutes | Rollback |
| Memory utilization | >85% for 5 minutes | Rollback |

These checks require production telemetry and should be evaluated by the deployment controller or CI/CD promotion gate.

---

### Category C — Manual Rollback

Manual rollback is required when:

- Gradual functional degradation is reported.
- Customer support reports indicate a possible release regression.
- A retroactive compliance failure is discovered.
- A downstream dependency is identified as the likely source of degradation.
- Automated telemetry is inconclusive.

The incident owner determines whether to rollback, hold the release, or continue investigation.

---

## 3. Local Automated Implementation

The reference implementation provides automated rollback for deployment and health failures.

`scripts/production-gate.sh` verifies:

1. Deployment replica readiness.
2. Pod running state.
3. HTTP `/health` availability.
4. Rollback when these checks fail.

`scripts/canary-rollback.sh` verifies:

1. Canary endpoints exist.
2. A canary pod exists.
3. Canary `/health` returns HTTP 200.
4. Rollback when these checks fail.

The local Kind demonstration does not collect live Prometheus metrics for HTTP error rate, p99 latency, CPU, memory, transaction success rate, or error-budget burn. Therefore those metric thresholds are specified as production integration requirements rather than falsely represented as locally automated.

---

## 4. Rollback Target

Production traffic is routed through the `novapay-stable` Service.

The rollback target is the known-good BLUE deployment.

Expected rollback path:

```text
GREEN release
    |
    | failure detected
    v
novapay-stable
    |
    v
BLUE known-good deployment
```
## 5. Rollback Verification

After rollback:

```bash
kubectl get svc novapay-stable -n novapay \
  -o jsonpath='{.spec.selector}'
```
Expected selector:

app=novapay,version=blue

Verify production traffic:

curl -s http://localhost:8081/version

Expected response:

{"version":"blue"}

Health verification:

curl -s http://localhost:8081/health

The response must indicate a healthy application.

---

## 6. Database Rollback Constraint

Application rollback must not depend on destructive database rollback.

Database changes follow the expand-migrate-contract model:

1. EXPAND — add backward-compatible schema.
2. MIGRATE — backfill or transform data.
3. CONTRACT — remove obsolete schema only after compatibility is confirmed.

Contract migrations are forward-only and require explicit approval.

If migration latency increases beyond the 20% gate:

Migration must be aborted.

The application deployment may then be rolled back while preserving the backward-compatible expanded schema.

---

## 7. Evidence Requirements

Rollback evidence should include:

- Deployment state before promotion.
- GREEN promotion confirmation.
- Production version after promotion.
- Rollback command/output.
- BLUE service selector after rollback.
- Production /version response after rollback.
- Health-check response.
- Relevant CI/CD run identifier.

All rollback events should be retained in the deployment and audit trail.

---

## 8. Production Integration Requirements

For a production deployment, the following integrations are required:

- Prometheus metrics for error rate, latency, CPU, and memory.
- OpenTelemetry traces for transaction and dependency analysis.
- Kubernetes health and lifecycle events.
- Database connection-pool and migration telemetry.
- Deployment controller integration for automated rollback.
- Immutable deployment and audit records.

These integrations allow the Category A and Category B thresholds to be evaluated automatically.

---

## 9. Safety Principle

Rollback should restore the last known-good application version without destroying backward-compatible database state.

The deployment system must prefer a fast, reversible traffic change over destructive infrastructure changes during an incident.

---

## AI Attribution

AI assistance was used for drafting, structuring, reviewing, and troubleshooting parts of this deliverable. Final technical decisions, validation, testing, and repository implementation were reviewed by the author.
