# Changelog

## 2025-06-04 aequify-ive:stable-1.00.1.9999 0001

```txt
Fix volatile entry signal direction inconsistency

Fixed critical issue where spike detection was triggering long/spot signals and drop detection was triggering short signals due to incorrect price movement validation logic in VolatileEntryService and swing analysis prioritization in TickCandleService.
```