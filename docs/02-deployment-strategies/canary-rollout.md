# NovaPay Canary Deployment Strategy

## Objective

Canary deployment gradually exposes a new application version to production traffic while continuously validating reliability, latency, and transaction success.

The implementation in this repository demonstrates controlled canary routing using the `X-Canary: true` request header. The rollout policy below defines the production-grade progressive rollout model.

## Progressive Rollout

| Phase | Traffic | Duration | Promotion Criteria |
|---|---:|---:|---|
| Phase 1 | 1–2% | 15 min | Error rate <0.1%, p99 <200ms |
| Phase 2 | 5–10% | 30 min | Error rate <0.05%, no critical alerts |
| Phase 3 | 25–50% | 60 min | All SLOs satisfied, no degradation |
| Phase 4 | 100% | 24h bake | Stable production metrics |

Promotion occurs only when the current phase satisfies all required gates.

## Automated Rollback Triggers

The canary is rolled back immediately when any Category A condition occurs:

- HTTP 5xx >5% for 60 seconds
- Three consecutive health-check failures
- OOM kill detected
- CrashLoopBackOff detected
- Database connection-pool exhaustion

Category B conditions trigger escalation and rollback evaluation:

- p99 latency >2x baseline for 5 minutes
- Error-budget burn >10x for 10 minutes
- Transaction success rate decreases by >2%
- CPU >90% or memory >85% for 5 minutes

Category C conditions require manual release-owner assessment:

- Gradual degradation
- Customer/support reports
- Retroactive compliance failure
- Correlated downstream dependency failure

## Statistical Validation

Canary metrics are compared against a rolling 7-day production baseline.

### Latency

Welch's t-test is used to compare canary and baseline latency distributions.

Promotion requires:

- No statistically significant harmful latency degradation
- p99 latency remains below the phase threshold
- 95% confidence level

### Error Rate

A chi-squared test is used to compare canary and baseline error rates.

Promotion requires:

- Error rate below the phase threshold
- No statistically significant increase in failures
- 95% confidence level

## Rollback Procedure

```text
Deploy Canary
     |
     v
Route Small Traffic
     |
     v
Observe Metrics
     |
     +---- FAIL ----> Rollback to Stable
     |
     v
Promotion Gate
     |
     v
Increase Traffic
     |
     v
Repeat Validation
     |
     v
100% Production
     |
     v
24h Bake
