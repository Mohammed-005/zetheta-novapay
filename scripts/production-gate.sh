#!/bin/bash
set -euo pipefail

NAMESPACE="novapay"
SERVICE="novapay"

echo "======================================"
echo " NovaPay Production Verification Gate"
echo "======================================"

echo "[1/4] Checking deployment availability..."

READY=$(kubectl get deployment -n "$NAMESPACE" "$SERVICE" \
  -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")

DESIRED=$(kubectl get deployment -n "$NAMESPACE" "$SERVICE" \
  -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "0")

echo "Ready replicas: ${READY:-0}"
echo "Desired replicas: ${DESIRED:-0}"

if [ "${READY:-0}" -lt "${DESIRED:-1}" ]; then
    echo "FAIL: Not all production replicas are ready."
    echo "Triggering rollback..."
    ./scripts/rollback.sh
    exit 1
fi

echo "[2/4] Checking pod health..."

UNHEALTHY=$(kubectl get pods -n "$NAMESPACE" \
  -l app=novapay \
  --field-selector=status.phase!=Running \
  --no-headers 2>/dev/null | wc -l)

if [ "$UNHEALTHY" -gt 0 ]; then
    echo "FAIL: Unhealthy production pods detected."
    ./scripts/rollback.sh
    exit 1
fi

echo "[3/4] Running HTTP health check..."

kubectl run novapay-gate-check \
  -n "$NAMESPACE" \
  --rm \
  --restart=Never \
  --image=curlimages/curl:8.10.1 \
  --command -- \
  curl -fsS --max-time 5 \
  "http://${SERVICE}/health"

echo
echo "HTTP health check PASSED."

echo "[4/4] Production verification PASSED."
echo "No rollback required."
