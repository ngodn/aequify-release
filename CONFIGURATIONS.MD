# Configuration Guide

## Top-Level Structure

```json
{
    "account_id": "string",
    "filters": {...},
    "risk_management": {...},
    "trading": {...},
    "plugin": {...},
    "developer": {...}
}
```

## Account ID

- **account_id**: Your Binance account ID as a string

## Filters

Configure entry, DCA, and exit filters for trading strategies. Each filter type can have its own configuration.

### Entry Filters

#### Price Change 24hr Filter

```json
"pricechangepct24hr_filter": {
    "enabled": true,
    "spot": {
        "pct_higher_than": 100.0,
        "pct_lower_than": -100.0
    },
    "futures": {
        "long": {
            "pct_higher_than": 5.0,
            "pct_lower_than": -3.5
        },
        "short": {
            "pct_higher_than": 20.0,
            "pct_lower_than": -100.0
        }
    }
}
```

Filters symbols based on 24-hour price change percentage thresholds.

#### Symbol Filter

```json
"symbol_filter": {
    "enabled": true,
    "pair": "USDT",
    "blacklist": ["ALPACA", "XEM", "TROY"],
    "whitelist": ["CHILLGUY", "TURBO", "MOODENG"]
}
```

- **pair**: Base pair for trading (e.g., "USDT")
- **blacklist**: Symbols to exclude from trading
- **whitelist**: Symbols to prioritize (overrides blacklist)

#### Age Filter

```json
"age_filter": {
    "enabled": true,
    "older_than": "1d"
}
```

Only trade symbols that have been listed for at least the specified duration (1m, 1h, 1d, etc.).

#### Support/Resistance Filter

```json
"support_filter": {
    "enabled": true,
    "timeframe": "1h",
    "minimum_n_of_level": 2
},
"resistance_filter": {
    "enabled": true,
    "timeframe": "1h",
    "minimum_n_of_level": 2
}
```

Requires minimum number of support/resistance levels within the specified timeframe.

#### Bollinger Band Swing Filter

```json
"bollingerband_swing_filter": {
    "enabled": true,
    "length": 20,
    "stddev_mult": 3,
    "source": "CLOSE",
    "n_candle_for_signal_lookback": 8,
    "signal_bb_timeframe": ["1h", "4h", "1d"],
    "n_candle_for_confirmation_lookback": 3,
    "confirmation_bb_timeframe": "1h",
    "skip_bb_confirmation": true,
    "confirm_on_passing_sr_level_timeframe": "1h",
    "confirm_on_passing_n_of_sr_level": 2,
    "skip_sr_level_confirmation": true
}
```

Uses Bollinger Bands to identify swing trading opportunities.

### DCA and Exit Filters

DCA and exit sections use the same filter structure as entry filters, typically with simplified configurations.

<!-- ## Risk Management

```json
"risk_management": {
    "auto_profit_transfer": {
        "enabled": true,
        "target_wallet": "FUNDING",
        "daily_profit_pct_threshold": 50.0
    },
    "time_based_stoploss": {
        "enabled": true,
        "activate_only_for_position_with_size_less_than": 20.0,
        "activate_when_ROI_pct_is": -50.0,
        "exit_mode": "FORCE_CLOSE_POSITION"
    }
}
```

- **auto_profit_transfer**: Automatically transfer profits when daily threshold is reached
- **time_based_stoploss**: Stop loss based on time and ROI thresholds -->

## Trading Configuration

### Spot Trading

```json
"spot": {
    "enabled": false,
    "wallet_exposure_per_symbol": 150
}
```

### Futures Trading

```json
"futures": {
    "long_enabled": true,
    "short_enabled": true,
    "margin_mode": "CROSSED", // or "ISOLATED"
    "leverage": 10,
    "wallet_exposure_per_symbol": 1000
}
```

### Strategy Configuration

Each strategy type (spot, long, short) has the following structure:

#### Entry Configuration

```json
"entry": {
    "initial_entry_quantity_in_usdt": 6.5,
    "hover_distance_pct": -0.3,
    "hover_refresh_interval_s": 5,
    "invalidate_timeframe": "1m"
}
```

#### DCA Configuration

```json
"dca": {
    "mode": "hovering_dca",  // or "snr"
    "snr": {
        "lookback_period": "3M",
        "max_n_of_dca": 2,
        "level_selection": "FARTHEST", // available option: CLOSEST, EVEN
        "dca_size_multiplier": 2.5
    },
    "hovering_dca": {
        "hover_distance_pct": -0.75,
        "hover_refresh_interval_s": 5,
        "dca_size_multiplier": 2.5,
        "max_position_size_in_usdt": 100
    }
}
```

#### Trailing Take Profit (spot or long)

```json
"trailing_tp": {
    "static_tp_distance_pct": 2.0,
    "trailing_activation_distance_pct_from_position_price": 0.3,
    "trailing_tp_interval_s": 10,
    "tp_upperbound": {
        "order_type": "LIMIT",
        "distance_pct_from_current_price": 1.0
    },
    "tp_lowerbound": {
        "order_type": "STOP",
        "distance_pct_from_current_price": -0.25
    }
}
```

#### Trailing Take Profit (short)

```json
"trailing_tp": {
    "static_tp_distance_pct": 5.0,
    "trailing_activation_distance_pct_from_position_price": -0.3,
    "trailing_tp_interval_s": 10,
    "tp_upperbound": {
        "order_type": "STOP",
        "distance_pct_from_current_price": 0.25
    },
    "tp_lowerbound": {
        "order_type": "LIMIT",
        "distance_pct_from_current_price": -1.0
    }
}
```

## Plugins

### Support and Resistance (SNR)

```json
"eins0fxSNR": {
    "enabled": true,
    "session": "0000-0100", // UTC 00:00 to 01:00
    "source": "CLOSE",
    "lookback_period": "3M"
}
```

### Volatile Entry

```json
"volatile_entry": {
    "enabled": true,
    "filters_to_disable": [
        "support_filter",
        "resistance_filter",
        "bollingerband_swing_filter"
    ],
    "tickbars": {
        "ticks_count_per_candle": 24,
        "history_type": "LAST_PRICE",
        "range": "30m"
    },
    "entry_validation": {
        "spot": {
            "minimum_price_change_pct": 1.0,
            "detection_time_window_s": 180,
            "minimum_drop_angle": -30,
            "entry_type": "INSTANT" // or "HOVER"
        },
        "long": {
            "minimum_price_change_pct": 1.0,
            "detection_time_window_s": 180,
            "minimum_drop_angle": -30,
            "entry_type": "INSTANT" // or "HOVER"
        },
        "short": {
            "minimum_price_change_pct": 1.5,
            "detection_time_window_s": 180,
            "minimum_spike_angle": 30,
            "entry_type": "INSTANT" // or "HOVER"
        }
    }
}
```

### Database Configuration

```json
"redis": {
    "hostname": "redis",
    "port": 6379
},
"postgres": {
    "hostname": "postgres",
    "port": 5432,
    "POSTGRES_USER": "aequifive",
    "POSTGRES_PASSWORD": "aequifive",
    "POSTGRES_DB": "aequifive"
}
```

## Developer Settings

```json
"developer": {
    "websocket_streams": {
        "max_streams": 700,
        "max_connections": 100
    },
    "state_sync_check_interval_s": {
        "positions_rest_api": 7,
        "filters": 300
    },
    "log_debug": {
        "api_request": false,
        "api_response": false,
        "websocket": false,
        "candlestore": false,
        "volatile_entry": false,
        "snr": false,
        "dca": false,
        "position_manager": false,
        "tp": false
    },
    "run_optimizer_in_background": {
        "volatile_entry": {
            "enabled": true,
            "output_file_name": "opt_volatile_entry_result.txt",
            "time_window_s": 3600
        }
    }
}
```

## Configuration Loading

The configuration is loaded from `user_data/config.json` at application startup. If the file doesn't exist, the application will throw a `ConfigurationError.fileNotFound` error.

The configuration loader also expects a separate `user_data/account.json` file for API credentials (not documented here for security reasons).

## Timeframe Format

Timeframes are specified as strings with the following format:

- Minutes: "1m", "5m", "15m", "30m"
- Hours: "1h", "2h", "4h", "6h", "8h", "12h"
- Days: "1d", "3d"
- Weeks: "1w"
- Months: "1M", "3M"

## Order Types

- **LIMIT**: Limit order
- **MARKET**: Market order
- **STOP**: Stop order
- **STOP_MARKET**: Stop market order
