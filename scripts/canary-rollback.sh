#!/bin/bash
set -euo pipefail

NAMESPACE="novapay"
CANARY_SERVICE="novapay-canary"
STABLE_SERVICE="novapay"

echo "=== NovaPay Canary Verification ==="

CANARY_ENDPOINTS=$(kubectl get endpointslice -n "$NAMESPACE" \
  -l "kubernetes.io/service-name=$CANARY_SERVICE" \
  -o jsonpath='{range .items[*].endpoints[*]}{.addresses[0]}{"\n"}{end}')

if [ -z "$CANARY_ENDPOINTS" ]; then
  echo "CRITICAL: Canary has no healthy endpoints."
  echo "Rolling production traffic back to BLUE..."
  ./scripts/rollback.sh
  exit 1
fi

echo "Canary endpoints detected:"
echo "$CANARY_ENDPOINTS"

CANARY_POD=$(kubectl get pods -n "$NAMESPACE" \
  -l app=novapay,version=canary \
  -o jsonpath='{.items[0].metadata.name}')

if [ -z "$CANARY_POD" ]; then
  echo "CRITICAL: Canary pod not found."
  ./scripts/rollback.sh
  exit 1
fi

STATUS=$(kubectl exec -n "$NAMESPACE" "$CANARY_POD" -- \
  python -c "import urllib.request; print(urllib.request.urlopen('http://127.0.0.1:8080/health', timeout=3).status)" \
  2>/dev/null || echo "000")

if [ "$STATUS" != "200" ]; then
  echo "CRITICAL: Canary health check failed: HTTP $STATUS"
  echo "Rolling production traffic back to BLUE..."
  ./scripts/rollback.sh
  exit 1
fi

echo "Canary health check PASSED."
echo "Canary deployment is healthy."
