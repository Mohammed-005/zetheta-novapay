# NovaPay Digital Bank
## Zero-Downtime CI/CD Pipeline with Compliance Gates

---

# Slide 1 — Title

**NovaPay Digital Bank**

Zero-Downtime CI/CD Pipeline with Compliance Gates

DevOps & Cloud Engineer Assessment

---

# Slide 2 — Business Problem

NovaPay's legacy deployment process relied on manual SSH deployments.

Key problems:

- High deployment risk
- Long recovery time
- No automated compliance validation
- Limited deployment frequency
- Manual security checks
- Risk of production downtime

Target:

- Commit-to-production under 2 hours
- Five-nines availability
- Automated security and compliance gates

---

# Slide 3 — Proposed Architecture

```text
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
   +--> SBOM
   +--> DAST
   +--> OPA Compliance
   |
   v
Container Registry
   |
   v
Kubernetes
   |
   +--> Blue / Green
   +--> Canary
   |
   v
Prometheus / Grafana

---

## AI Attribution

AI assistance was used for drafting, structuring, reviewing, and troubleshooting parts of this deliverable. Final technical decisions, validation, testing, and repository implementation were reviewed by the author.
