# NovaPay Database Migration Compatibility Matrix

## Expand-Contract Strategy

NovaPay database changes follow an expand-contract approach so that old and new application versions can coexist during deployment.

## Compatibility Matrix

| Application Version | Old Schema | Expanded Schema | Contracted Schema |
|---|---:|---:|---:|
| V(N-1) | ✅ | ✅ | ❌ |
| V(N) | ❌ | ✅ | ✅ |

### Explanation

- V(N-1) continues working after the EXPAND phase.
- V(N) is deployed only after the expanded schema is available.
- The CONTRACT phase occurs only after all services have migrated to V(N).
- The old application must never be exposed to a schema after its required legacy fields have been removed.

## Migration Phases

### 1. EXPAND

Add new database structures without removing existing structures.

Example:

```sql
ALTER TABLE customers ADD COLUMN risk_score INTEGER;
