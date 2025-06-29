# `aequify-gematria` Configuration

`user_data/config.json`

## Table of Contents

- [Account Configuration](#account-configuration)
- [Trading Configuration](#trading-configuration)
- [Filters](#filters)
- [Engines](#engines)
- [Developer Settings](#developer-settings)

## Account Configuration

### `accountId`
- **Type**: String
- **Description**: Your Binance user ID for account identification
- **Example**: `"YOUR_BINANCE_USER_ID"`
- **Required**: Yes

## Trading Configuration

### `trading.disableTradingOnWindowUTC`
- **Type**: Array of arrays
- **Description**: Time windows in UTC when trading should be disabled (24-hour format)
- **Format**: `[startHour, endHour]` where hours are in 24-hour format (0-23)
- **Example**: `[[21, 23]]` disables trading from 21:00 to 23:59 UTC
- **Default**: `[[2100, 2359]]`

### `trading.futures.marginMode`
- **Type**: String
- **Description**: Margin mode for futures trading
- **Options**: 
  - `"ISOLATED"` - Isolated margin mode
  - `"CROSS"` - Cross margin mode
- **Default**: `"ISOLATED"`

### `trading.futures.leverage`
- **Type**: Number
- **Description**: Leverage multiplier for futures positions
- **Range**: 1-125 (depending on symbol)
- **Default**: `10`

### `trading.futures.long`
Configuration for long (buy) positions

#### `trading.futures.long.enabled`
- **Type**: Boolean
- **Description**: Enable/disable long position trading
- **Default**: `true`

#### `trading.futures.long.initialEntrySizeUSDT`
- **Type**: Number
- **Description**: Initial position size in USDT for long positions
- **Default**: `6.5`

#### `trading.futures.long.maximumPositionSizeUSDT`
- **Type**: Number
- **Description**: Maximum allowed position size in USDT for long positions
- **Default**: `100.0`

#### `trading.futures.long.riskManagement`
- **Type**: String
- **Description**: Risk management strategy for long positions
- **Options**:
  - `"PRIORITIZE_DCA"` - Prioritize Dollar Cost Averaging
- **Default**: `"PRIORITIZE_DCA"`

### `trading.futures.short`
Configuration for short (sell) positions

#### `trading.futures.short.enabled`
- **Type**: Boolean
- **Description**: Enable/disable short position trading
- **Default**: `true`

#### `trading.futures.short.initialEntrySizeUSDT`
- **Type**: Number
- **Description**: Initial position size in USDT for short positions
- **Default**: `6.5`

#### `trading.futures.short.maximumPositionSizeUSDT`
- **Type**: Number
- **Description**: Maximum allowed position size in USDT for short positions
- **Default**: `100.0`

#### `trading.futures.short.riskManagement`
- **Type**: String
- **Description**: Risk management strategy for short positions
- **Options**:
  - `"PRIORITIZE_DCA"` - Prioritize Dollar Cost Averaging
- **Default**: `"PRIORITIZE_DCA"`

## Filters

Filters are applied to trading symbols to determine which ones should be considered for trading.

### `filters[].name`
- **Type**: String
- **Description**: Name of the filter to apply
- **Required**: Yes

### `filters[].enabled`
- **Type**: Boolean
- **Description**: Enable/disable this specific filter
- **Default**: `true`

### `filters[].config`
- **Type**: Object
- **Description**: Configuration specific to the filter type
- **Required**: Yes

### Available Filters

#### 1. `absolute_price_percentage_change`
Filters symbols based on their price percentage change.

**Config Options:**
- `top`: Number - Number of top symbols to select based on percentage change
- **Example**: `{"top": 40}` selects the top 40 symbols by percentage change

#### 2. `symbol_filter`
Filters symbols based on inclusion/exclusion lists.

**Config Options:**
- `pair`: String - Base currency pair (e.g., "USDT")
- `blacklist`: Array of strings - Symbols to exclude from trading
- `whitelist`: Array of strings - Symbols to include in trading (if specified, only these symbols are traded)

**Example:**
```json
{
    "pair": "USDT",
    "blacklist": ["BTC", "ETH", "SOL"],
    "whitelist": ["MYX"]
}
```

## Engines

### `engines.apex`
- **Description**: Documentation in progress
- **Enabled**: `true`

## Developer Settings

### `developer.logLevel`
- **Type**: String
- **Description**: Logging level for the application
- **Options**:
  - `"DEBUG"` - Most verbose logging
  - `"INFO"` - Standard information logging
  - `"WARN"` - Warning messages only
  - `"ERROR"` - Error messages only
- **Default**: `"INFO"`

### `developer.receiveWindow`
- **Type**: Number
- **Description**: Receive window for API requests in milliseconds
- **Default**: `4000`

## Example Configuration

```json
{
    "accountId": "YOUR_BINANCE_USER_ID",
    "trading": {
        "disableTradingOnWindowUTC": [[21, 23]],
        "futures": {
            "marginMode": "ISOLATED",
            "leverage": 10,
            "long": {
                "enabled": true,
                "initialEntrySizeUSDT": 6.5,
                "maximumPositionSizeUSDT": 100.0,
                "riskManagement": "PRIORITIZE_DCA"
            },
            "short": {
                "enabled": true,
                "initialEntrySizeUSDT": 6.5,
                "maximumPositionSizeUSDT": 100.0,
                "riskManagement": "PRIORITIZE_DCA"
            }
        }
    },
    "filters": [
        {
            "name": "absolute_price_percentage_change",
            "enabled": true,
            "config": {
                "top": 40
            }
        },
        {
            "name": "symbol_filter",
            "enabled": true,
            "config": {
                "pair": "USDT",
                "blacklist": ["BTC", "ETH"],
                "whitelist": ["MYX"]
            }
        }
    ],
    "engines": {
        "apex": {
            "enabled": true
        }
    },
    "developer": {
        "logLevel": "INFO",
        "receiveWindow": 4000
    }
}
```

## Notes

- All monetary values are in USDT
- Time windows use 24-hour UTC format
- Filters are applied in the order they appear in the configuration
- The bot will respect the trading time windows and skip trading during disabled periods
- Risk management strategies may affect position sizing and entry/exit timing
