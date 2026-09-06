#!/bin/bash

set -e

NAMESPACE="novapay"
SERVICE="novapay"
ROLLBACK_VERSION="blue"

echo "Rolling back production traffic to $ROLLBACK_VERSION..."

kubectl patch service "$SERVICE" \
  -n "$NAMESPACE" \
  -p "{\"spec\":{\"selector\":{\"app\":\"novapay\",\"version\":\"$ROLLBACK_VERSION\"}}}"

echo "Rollback complete: traffic is now on $ROLLBACK_VERSION"
