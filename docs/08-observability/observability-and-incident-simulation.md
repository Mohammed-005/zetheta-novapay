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
