-- EXPAND PHASE
-- Backward-compatible schema change.
-- Existing application versions continue to work.

ALTER TABLE customers
ADD COLUMN IF NOT EXISTS risk_score INTEGER;

CREATE INDEX IF NOT EXISTS idx_customers_risk_score
ON customers(risk_score);
