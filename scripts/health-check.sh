#!/bin/bash

set -e

URL="${1:-http://localhost:8080/health}"
MAX_ATTEMPTS="${2:-10}"

echo "Checking application health: $URL"

for i in $(seq 1 "$MAX_ATTEMPTS"); do
    if curl --fail --silent "$URL" | grep -q '"status":"healthy"'; then
        echo "HEALTH CHECK PASSED"
        exit 0
    fi

    echo "Attempt $i/$MAX_ATTEMPTS failed..."
    sleep 2
done

echo "HEALTH CHECK FAILED"
exit 1
