-- MIGRATE PHASE
-- Populate the new field without removing old data.

UPDATE customers
SET risk_score = 0
WHERE risk_score IS NULL;
