# Changelog

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
