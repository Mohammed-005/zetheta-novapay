# NovaPay CI/CD & Production Reliability Dashboard

## DORA Metrics

| Metric | Target |
|---|---|
| Deployment Frequency | >= 1/day |
| Lead Time | < 120 minutes |
| Change Failure Rate | < 15% |
| MTTR | < 60 minutes |

## Pipeline Health

| Signal | Target |
|---|---|
| Build Success | > 95% |
| Gate Pass Rate | > 95% |
| Flaky Tests | Trending downward |
| Scanner False Positives | Monitored |

## Production SLO Signals

- HTTP 5xx rate
- p99 latency
- CPU utilization
- Memory utilization
- Pod readiness
- Transaction success rate
- Database connection pool usage
- Error-budget burn

## Automated Rollback Signals

### Category A — Immediate
- 5xx > 5% for 60 seconds
- 3 consecutive health failures
- OOM
- CrashLoopBackOff
- DB pool exhaustion

### Category B — <15 minutes
- p99 > 2x baseline for 5 minutes
- Error-budget burn >10x for 10 minutes
- Transaction success decreases >2%
- CPU >90% for 5 minutes
- Memory >85% for 5 minutes

### Category C — Manual
- Gradual degradation
- Support reports
- Retroactive compliance failure
- Downstream correlation

> **AI Attribution Block**
>
> This artifact was created with AI assistance for the NovaPay DevOps assessment. The author reviewed, validated, and adapted the content and implementation.
