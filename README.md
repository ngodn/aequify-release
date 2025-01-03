# Aequify

Aequify is a sophisticated automated trading system designed for cryptocurrency futures trading. It implements multiple trading strategies with dynamic position management, including entry conditions, Dollar-Cost Averaging (DCA), and take-profit mechanisms.

## License

This project is licensed under proprietary terms. Unauthorized distribution, modification, or commercial use is strictly prohibited.

## Contact

For inquiries, support, or license information, please contact through:
- Instagram: [@aequify](https://www.instagram.com/aequify/profilecard/?igsh=eGE1aXg4Ym9iYTVm)
- Discord: [https://discord.gg/4G8qyyejwh](https://discord.gg/4G8qyyejwh)

## Version

Current stable version: `stable-0.14.0.4`

## Supported Exchanges

Currently supported:
- Binance Futures USD-M

More exchanges will be available in future updates.

## Configuration Guide

The system is configured through a `config.json` file that controls all aspects of the trading behavior. Here's a detailed explanation of each configuration section:

### Basic Configuration

```json
{
  "account_id": "123456789",
  "blacklisted_symbols": ["BTCUSDT", "OCEANUSDT"],
  "minimum_price_change_percent": 13.0,
  "state_sync_interval_s": 10
}
```

- `account_id`: Your trading account identifier
- `blacklisted_symbols`: Trading pairs to exclude from trading
- `minimum_price_change_percent`: Minimum price volatility required to consider a trading pair
- `state_sync_interval_s`: How often (in seconds) the system synchronizes its state

### Strategy Configuration

The strategy configuration is divided into long and short positions. Each has its own set of parameters optimized for their respective trading directions.

## Long Strategy

### Position Management
```json
"long": {
  "max_running_symbols": 7,
  "exchange_leverage": 10,
  "wallet_exposure_per_symbol": 500
}
```

- `max_running_symbols`: Maximum number of concurrent positions
- `exchange_leverage`: Trading leverage used (e.g., 10x)
- `wallet_exposure_per_symbol`: Maximum wallet exposure per position in USDT

### Entry Strategy
```json
"entry": {
  "min_ticks": 10,
  "price_change_interval_s": 13,
  "price_change_threshold": -0.01
}
```

This controls how positions are entered:
- `min_ticks`: Minimum number of price updates required before entry
- `price_change_interval_s`: Time window to monitor price changes (in seconds)
- `price_change_threshold`: Required price change to trigger entry (-0.01 = -1% drop for long)

### Hovering DCA (Dollar-Cost Averaging)
```json
"hovering_dca": {
  "hover_distance": -0.01,
  "hover_price_change_interval_s": 13,
  "hover_activation_distance_from_position_price": -0.0025,
  "number_of_dca": 2,
  "dca_size_multiplier": 4.55
}
```

DCA mechanism that activates when price moves against the position:
- `hover_distance`: Price distance to place DCA orders (-0.01 = 1% below current price)
- `hover_price_change_interval_s`: How often to check DCA conditions
- `hover_activation_distance_from_position_price`: When to activate DCA (-0.0025 = -0.25% from entry)
- `number_of_dca`: Maximum number of DCA orders
- `dca_size_multiplier`: Size multiplier for each DCA order (4.55 means each DCA is 4.55x the previous order)

### Trailing Take-Profit
```json
"trailing_tp": {
  "static_tp_distance": 0.015,
  "trailing_activation_distance_from_position_price": 0.0075,
  "trailing_tp_interval_s": 5,
  "tp_upperbound": {
    "order_type": "LIMIT",
    "distance_from_current_price": 0.0035,
    "invalidate_threshold_from_current_price": 0.0025
  },
  "tp_lowerbound": {
    "order_type": "STOP",
    "distance_from_current_price": -0.0025,
    "invalidate_threshold_from_current_price": -0.0025
  }
}
```

Dynamic take-profit mechanism:
- `static_tp_distance`: Initial take-profit target (0.015 = 1.5% above entry)
- `trailing_activation_distance`: When to activate trailing (0.0075 = 0.75% profit)
- `trailing_tp_interval_s`: How often to update trailing stops
- `tp_upperbound`: Upper take-profit boundary
  - `order_type`: LIMIT for direct take-profit at target price
  - `distance_from_current_price`: Price distance for the order (0.35% above)
  - `invalidate_threshold_from_current_price`: When to cancel and recreate the order
- `tp_lowerbound`: Lower take-profit boundary
  - `order_type`: STOP for stop-profit trigger when price pulls back
  - `distance_from_current_price`: Price distance for the order (0.25% below)
  - `invalidate_threshold_from_current_price`: When to cancel and recreate the order

### How Long Strategy Works

1. The system monitors all trading pairs for downward volatility exceeding `minimum_price_change_percent`
2. When a significant price drop is detected:
   - Waits for minimum 10 price ticks
   - Looks for 1% price drop within 13 seconds
   - Opens long position if criteria met and under maximum positions

3. After Entry:
   - Places initial take-profit at 1.5% above entry
   - Monitors price movement for DCA opportunities
   - Places DCA orders 1% below current price if price drops 0.25% below entry
   - Can execute up to 2 DCA orders, each 4.55x the size of the previous

4. Take-Profit Management:
   - Initially places a static take-profit order
   - When price moves up 0.75%, activates trailing mechanism
   - Places LIMIT order 0.35% above current price for direct profit-taking
   - Places STOP order 0.25% below current price to protect profits
   - Updates bounds every 5 seconds as price moves higher

## Short Strategy

### Position Management
```json
"short": {
  "max_running_symbols": 3,
  "exchange_leverage": 10,
  "wallet_exposure_per_symbol": 200
}
```

- `max_running_symbols`: Maximum number of concurrent short positions
- `exchange_leverage`: Trading leverage used (e.g., 10x)
- `wallet_exposure_per_symbol`: Maximum wallet exposure per position in USDT

### Entry Strategy
```json
"entry": {
  "min_ticks": 30,
  "price_change_interval_s": 13,
  "price_change_threshold": 0.02
}
```

Controls short position entry:
- `min_ticks`: Minimum number of price updates required before entry
- `price_change_interval_s`: Time window to monitor price changes (in seconds)
- `price_change_threshold`: Required price change to trigger entry (0.02 = 2% rise for short)

### Hovering DCA (Dollar-Cost Averaging)
```json
"hovering_dca": {
  "hover_distance": 0.025,
  "hover_price_change_interval_s": 10,
  "hover_activation_distance_from_position_price": 0.1,
  "number_of_dca": 1,
  "dca_size_multiplier": 4.55
}
```

DCA mechanism that activates when price moves against the short position:
- `hover_distance`: Price distance to place DCA orders (2.5% above current price)
- `hover_price_change_interval_s`: How often to check DCA conditions
- `hover_activation_distance_from_position_price`: When to activate DCA (10% above entry)
- `number_of_dca`: Maximum number of DCA orders
- `dca_size_multiplier`: Size multiplier for DCA order (4.55x the initial position)

### Trailing Take-Profit
```json
"trailing_tp": {
  "static_tp_distance": -0.015,
  "trailing_activation_distance_from_position_price": -0.0075,
  "trailing_tp_interval_s": 3,
  "tp_upperbound": {
    "order_type": "STOP",
    "distance_from_current_price": 0.0025,
    "invalidate_threshold_from_current_price": 0.0025
  },
  "tp_lowerbound": {
    "order_type": "LIMIT",
    "distance_from_current_price": -0.0035,
    "invalidate_threshold_from_current_price": -0.0025
  }
}
```

Dynamic take-profit mechanism for shorts:
- `static_tp_distance`: Initial take-profit target (1.5% below entry)
- `trailing_activation_distance`: When to activate trailing (0.75% profit)
- `trailing_tp_interval_s`: How often to update trailing stops
- `tp_upperbound`: Upper boundary to protect profits
  - `order_type`: STOP for stop-profit trigger when price bounces
  - `distance_from_current_price`: Price distance for the order (0.25% above)
  - `invalidate_threshold_from_current_price`: When to cancel and recreate the order
- `tp_lowerbound`: Lower boundary for profit-taking
  - `order_type`: LIMIT for direct take-profit at target price
  - `distance_from_current_price`: Price distance for the order (0.35% below)
  - `invalidate_threshold_from_current_price`: When to cancel and recreate the order

### How Short Strategy Works

1. The system monitors trading pairs for upward volatility exceeding `minimum_price_change_percent`
2. When a significant price rise is detected:
   - Waits for minimum 30 price ticks
   - Looks for 2% price rise within 13 seconds
   - Opens short position if criteria met and under maximum positions

3. After Entry:
   - Places initial take-profit at 1.5% below entry
   - Monitors price movement for DCA opportunities
   - Places DCA order 2.5% above current price if price rises 10% above entry
   - Limited to 1 DCA order at 4.55x the initial position size

4. Take-Profit Management:
   - Initially places a static take-profit order
   - When price moves down 0.75%, activates trailing mechanism
   - Places STOP order 0.25% above current price to protect profits
   - Places LIMIT order 0.35% below current price for direct profit-taking
   - Updates bounds every 3 seconds as price moves lower

## Risk Management (Coming Soon)

The following risk management features will be available in the next version update:

```json
"risk_management": {
  "auto_profit_transfer": {
    "enabled": false,
    "target_wallet": "FUNDING",
    "daily_profit_pct_threshold": 0.5
  },
  "auto_hedge": {
    "enabled": false,
    "activation_distance_from_opposite_position_price": 1.25,
    "quantity_pct_from_opposite_position_quantity": 0.05
  },
  "auto_reduce_stuck_position": {
    "enabled": false,
    "unrealized_pct_activation_threshold": -1.5,
    "quantity_pct_to_reduce_from_position_quantity": 0.1,
    "reduced_unrealized_pct_activation_threshold": 0.5
  },
  "no_entry_only_exit": {
    "enabled": false
  }
}
```

Planned risk management features:
- `auto_profit_transfer`: Automatically transfer profits to funding wallet
- `auto_hedge`: Create hedge positions automatically
- `auto_reduce_stuck_position`: Reduce losing positions automatically
- `no_entry_only_exit`: Disable new entries while allowing exits

Note: These features are currently under development and will be available in a future release. For now, please keep the `risk_management` section in your config but leave all features disabled.