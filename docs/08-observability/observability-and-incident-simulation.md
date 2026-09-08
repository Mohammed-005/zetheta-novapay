# NovaPay Observability & Incident Simulation

## 1. Observability Architecture

NovaPay uses the following observability model:

```text
Application
    |
    +--> Metrics --------> Prometheus --------> Grafana
    |
    +--> Logs -----------> Loki
    |
    +--> Traces ----------> OpenTelemetry / Jaeger
    |
    +--> Alerts ----------> Alertmanager
                                      |
                                      v
                              Incident Response

---

## AI Attribution

AI assistance was used for drafting, structuring, reviewing, and troubleshooting parts of this deliverable. Final technical decisions, validation, testing, and repository implementation were reviewed by the author.
