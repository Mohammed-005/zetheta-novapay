#!/bin/bash
set -euo pipefail

NAMESPACE="novapay"
STABLE_SERVICE="novapay-stable"

echo "Production verification gate"
echo "============================="

echo "[1/4] Checking stable service..."

STABLE_VERSION=$(kubectl get svc "$STABLE_SERVICE" \
  -n "$NAMESPACE" \
  -o jsonpath='{.spec.selector.version}')

if [[ -z "$STABLE_VERSION" ]]; then
  echo "FAIL: Could not determine stable version."
  echo "Triggering rollback..."
  ./scripts/rollback.sh
  exit 1
fi

DEPLOYMENT="novapay-${STABLE_VERSION}"

echo "Stable version: $STABLE_VERSION"
echo "Deployment: $DEPLOYMENT"

kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE"

READY=$(kubectl get deployment "$DEPLOYMENT" \
  -n "$NAMESPACE" \
  -o jsonpath='{.status.readyReplicas}')

DESIRED=$(kubectl get deployment "$DEPLOYMENT" \
  -n "$NAMESPACE" \
  -o jsonpath='{.spec.replicas}')

if [[ "$READY" != "$DESIRED" ]]; then
  echo "FAIL: Deployment is not fully ready."
  echo "Ready: ${READY:-0}/${DESIRED}"
  echo "Triggering rollback..."
  ./scripts/rollback.sh
  exit 1
fi

echo "[2/4] Checking production pods..."

UNHEALTHY=$(kubectl get pods \
  -n "$NAMESPACE" \
  -l "app=novapay,version=$STABLE_VERSION" \
  --field-selector=status.phase!=Running \
  --no-headers 2>/dev/null | wc -l)

if [[ "$UNHEALTHY" -gt 0 ]]; then
  echo "FAIL: Unhealthy production pods detected."
  ./scripts/rollback.sh
  exit 1
fi

echo "Production pods are healthy."

echo "[3/4] Checking application health..."

kubectl run production-health-check \
  -n "$NAMESPACE" \
  --rm -i \
  --restart=Never \
  --image=curlimages/curl:8.10.1 \
  -- \
  curl -fsS --max-time 5 \
  "http://${STABLE_SERVICE}/health"

echo
echo "[4/4] Verifying active version..."

ACTIVE_VERSION=$(kubectl run production-version-check \
  -n "$NAMESPACE" \
  --rm -i \
  --restart=Never \
  --image=curlimages/curl:8.10.1 \
  -- \
  curl -fsS --max-time 5 \
  "http://${STABLE_SERVICE}/version")

echo "Active version response: $ACTIVE_VERSION"

if ! echo "$ACTIVE_VERSION" | grep -q "\"version\":\"$STABLE_VERSION\""; then
  echo "FAIL: Active version does not match stable service selector."
  echo "Triggering rollback..."
  ./scripts/rollback.sh
  exit 1
fi

echo "Production verification PASSED."
echo "No rollback required."
