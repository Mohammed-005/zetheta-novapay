#!/bin/bash

set -e

NAMESPACE="novapay"
SERVICE="novapay"

CURRENT_VERSION=$(kubectl get service "$SERVICE" \
  -n "$NAMESPACE" \
  -o jsonpath='{.spec.selector.version}')

if [ "$CURRENT_VERSION" = "blue" ]; then
    ROLLBACK_VERSION="green"
else
    ROLLBACK_VERSION="blue"
fi

echo "Current version : $CURRENT_VERSION"
echo "Rollback target : $ROLLBACK_VERSION"

kubectl patch service "$SERVICE" \
  -n "$NAMESPACE" \
  -p "{\"spec\":{\"selector\":{\"app\":\"novapay\",\"version\":\"$ROLLBACK_VERSION\"}}}"

echo "Traffic rolled back to $ROLLBACK_VERSION"
