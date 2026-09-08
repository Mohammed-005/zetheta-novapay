# Reflection

## What I Built

I designed and implemented a reference CI/CD pipeline for the NovaPay banking
application assessment.

The project combines application testing, security scanning, compliance policy
evaluation, infrastructure validation, Kubernetes deployment strategies,
rollback automation, database migration planning, observability, and operational
runbooks.

## Key Learning

The most important learning was that a CI/CD pipeline is not only a sequence of
build commands. A production-oriented pipeline also needs security gates,
compliance controls, artifact traceability, deployment verification, rollback
conditions, database compatibility, and audit evidence.

I also learned the difference between demonstrating a deployment strategy and
claiming that it is fully production-grade. For example, the local canary
implementation demonstrates traffic separation, while a production deployment
would require real percentage-based traffic control and telemetry-driven
promotion.

## Troubleshooting Experience

Several pipeline controls required troubleshooting during implementation.

The OPA compliance stage initially evaluated the policy but did not explicitly
fail the workflow when the compliance expression was unsuccessful. The workflow
was updated to use a failing evaluation mode so that the compliance gate can
stop the pipeline.

Terraform provider and formatting/validation issues were also checked during the
implementation.

Kubernetes deployment behavior was tested using blue-green switching and
rollback, and the application version endpoint was used to verify which version
was receiving traffic.

## Security and Compliance Mindset

The project reinforced the importance of failing safely.

A deployment should not be promoted simply because the application builds
successfully. Security findings, compliance failures, missing approvals, and
deployment health conditions need to be capable of blocking promotion.

The OPA policy provides a machine-readable example of this principle.

## What I Would Improve

If this were moved toward a real production environment, I would next:

1. Use the assessment's Java 21/Spring Boot application stack.
2. Connect the pipeline to a real private container registry.
3. Implement real Cosign image signing and signature verification.
4. Use Prometheus metrics for automated canary promotion and rollback.
5. Integrate real PostgreSQL migration execution and latency monitoring.
6. Add stronger contract and integration testing against dependent services.
7. Implement production-grade secrets management.
8. Add complete audit-event storage and retention controls.
9. Deploy the infrastructure through a controlled cloud environment.
10. Perform failure-injection testing against the rollback thresholds.

## Final Reflection

The project helped me understand that zero-downtime delivery is a system-level
engineering problem. Application code, infrastructure, security, compliance,
database compatibility, observability, and operations all need to work together.

The most valuable outcome is not just the pipeline YAML, but the ability to
explain why each gate exists, what condition causes it to fail, how an operator
detects the failure, and how the deployment can be safely rolled back.

---

## AI Attribution

AI assistance was used for drafting, structuring, reviewing, and troubleshooting parts of this deliverable. Final technical decisions, validation, testing, and repository implementation were reviewed by the author.
