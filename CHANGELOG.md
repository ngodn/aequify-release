# Changelog

## `codename:gematria` eins0fx/aequify:gematria-0.33.666.0
```txt
- Introducing APEX Engine, Adaptive Parameter EXploration to adaptively change parameters in analysis engine based on Gradient Descent
- Major Bug Fixes for race conditions issues
- Spot is disabled in this version due to issues with dust assets
```

## 2025-06-04 0004 aequify-ive:stable-1.00.1.9999
```txt
- Replace invalidation method in Entry Strategy with time based check instead of BB
```

## 2025-06-04 0003 aequify-ive:stable-1.00.1.9999
```txt
- Fix critical database precondition issues
- Added pgadmin to compose stack
- Updated run scripts
```

## 2025-06-04 0002 aequify-ive:stable-1.00.1.9999
```txt
feat: add multiple timeframe support for entry strategy invalidation

  - Entry Strategy now invalidates if price crosses Bollinger Band middle on ANY configured timeframe
  - Maintains consistency with existing bollinger_band_swing_filter timeframe pattern
```

## 2025-06-04 0001 aequify-ive:stable-1.00.1.9999
```txt
Fix volatile entry signal direction inconsistency

Fixed critical issue where spike detection was triggering long/spot signals and drop detection was triggering short signals due to incorrect price movement validation logic in VolatileEntryService and swing analysis prioritization in TickCandleService.
```