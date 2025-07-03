# Changelog

## `eins0fx/aequify:gematria-0.33.666.3`
```
fix: separate tracker collections for independent window progressions

- Fix critical design flaw where multiple signal trackers competed for same consecutive windows
- Implement separate collections for each signal type (entryLong, entryShort, exitLong, exitShort)
- Add SignalType enum with proper signal categorization and description
- Ensure independent window progressions for each signal type
- Update multi-phase validation logic to work with separated trackers
- Fix signal emission logic to properly handle new signal types

This resolves the fundamental issue where multi-phase validation was meaningless due to tracker competition, ensuring each signal type has its own independent progression.
```

## `eins0fx/aequify:gematria-0.33.666.2`
```txt
feat: Implement multi-phase volume anomaly detection with consecutive window progression
BREAKING CHANGE: Complete rewrite of Volume Anomaly algorithm and data structures
```

## `eins0fx/aequify:gematria-0.33.666.1`
```txt
- Eliminated Volume Anomaly Detector rate limiting bottleneck that was preventing stable Adaptive Parameter EXploration operation 
- Centralized volatility management in Coordinator now provides the reliable, real-time market session data needed for APEX's dynamic parameter optimization without triggering Binance API bans that would disrupt the adaptive learning pipeline.
- Spot is disabled in this version due to issues with dust assets
```

## `eins0fx/aequify:gematria-0.33.666.0`
```txt
- Introducing APEX Engine, Adaptive Parameter EXploration to adaptively change parameters in analysis engine based on Gradient Descent
- Major Bug Fixes for race conditions issues
- Spot is disabled in this version due to issues with dust assets
```
