# Assessment Errata

This document records three technical or factual inconsistencies identified in
the assessment material. These corrections are kept separate from the
NovaPay implementation and do not represent defects in the submitted pipeline.

## 1. Part A — DORA Change Failure Rate Target

The assessment describes a Change Failure Rate of `<5%` as a DORA "Elite Target."

This should not be presented as the DORA elite classification itself. The
assessment target may be retained as a stricter NovaPay engineering objective,
but it should be clearly labeled as a project-specific target rather than a
DORA-defined elite threshold.

**Impact:** Documentation/classification only.

---

## 2. Part C — Cloudflare Outage Duration

The assessment states that the Cloudflare outage on July 2, 2019 lasted
21 minutes.

The outage duration should be recorded as approximately **27 minutes**.

**Impact:** Historical incident reference only.

---

## 3. Part D — Effort Calculation

The assessment states an estimated effort of **6–9 hours per day** over
**15 days**, while also giving a total of **100–135 hours**.

The stated daily range produces:

- 6 × 15 = **90 hours**
- 9 × 15 = **135 hours**

Therefore, the mathematically consistent range is **90–135 hours**.

**Impact:** Effort-estimation arithmetic only.

---

## Correction Policy

The NovaPay implementation and evidence package should be evaluated against
the assessment requirements while these inconsistencies are explicitly
documented here. No assessment text has been silently changed.
