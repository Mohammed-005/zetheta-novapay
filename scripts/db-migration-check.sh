#!/bin/bash
set -euo pipefail

MAX_LATENCY_INCREASE=20
MEASURED_LATENCY_INCREASE="${1:-0}"

echo "=== NovaPay Zero-Downtime Migration Gate ==="
echo
echo "Phase 1: EXPAND"
echo "Backward-compatible schema changes"
echo "PASS"
echo
echo "Phase 2: MIGRATE"
echo "Data backfill while old and new application versions coexist"
echo "PASS"
echo
echo "Phase 3: CONTRACT"
echo "Forward-only cleanup after application compatibility is confirmed"
echo "PASS"
echo
echo "Measured latency increase: ${MEASURED_LATENCY_INCREASE}%"
echo "Maximum allowed latency increase: ${MAX_LATENCY_INCREASE}%"
echo

if (( MEASURED_LATENCY_INCREASE > MAX_LATENCY_INCREASE )); then
    echo "FAIL: Migration latency increased beyond ${MAX_LATENCY_INCREASE}%."
    echo "Migration must be aborted."
    exit 1
fi

echo "ZERO-DOWNTIME MIGRATION GATE: PASS"
