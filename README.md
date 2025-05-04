# Aequify

Aequify is an advanced cryptocurrency futures trading system that automates price volatility trading on Binance Futures USD-M (USDT-Margined). The system specializes in:

1. Volatility Detection: Monitors and identifies significant price movements (configurable threshold) across all trading pairs
2. Smart Position Entry: Opens positions based on precise entry conditions with initial small position sizes and reversal protection
3. Dynamic Position Building: Uses a two-layer hovering DCA system that continuously adapts to price movements
   - Inner Layer: Aggressive averaging for smaller positions
   - Outer Layer: Safety net for larger drawdowns/rallies
4. Intelligent Exit Management: Implements trailing take-profit mechanisms that adjust to market movements to secure profits
5. Advanced Risk Management: Features auto-hedging, zero-sum strategy, profit transfer, and stuck position reduction

The system is designed for both long and short positions, with more aggressive parameters for longs (catching dips) and conservative settings for shorts (entering on price rises). It includes built-in risk management through position size limits, exposure control, directional trend filtering, and automatic order management.

## License

This project is licensed under proprietary terms. Unauthorized distribution, modification, or commercial use is strictly prohibited.

## Contact

For inquiries, support, or license information, please contact through:
- Instagram: [@aequify](https://www.instagram.com/aequify/profilecard/?igsh=eGE1aXg4Ym9iYTVm)
- Discord: [https://discord.gg/4G8qyyejwh](https://discord.gg/4G8qyyejwh)

## Version

Current stable version: `stable-0.99.1.8686`

## Supported Exchanges

Currently supported:
- Binance Futures USD-M

More exchanges will be available in future updates.

## Configuration Guide

The system is configured through a `config.json` file that controls all aspects of the trading behavior. Here's a detailed explanation of each configuration section:

### Basic Configuration

```json
{
  "account_id": "YOUR_BINANCE_USER_ID",
  "blacklisted_symbols": ["BTCUSDT", "OCEANUSDT", "DGBUSDT", "AGIXUSDT", "STRAXUSDT"],
  "minimum_price_change_percent": 13.0,
  "state_sync_interval_s": 10
}
```

- `account_id`: Your Binance user identifier
- `blacklisted_symbols`: Trading pairs to exclude from trading
- `minimum_price_change_percent`: Minimum price volatility required to consider a trading pair
- `state_sync_interval_s`: How often (in seconds) the system synchronizes its state

### Strategy Configuration

The system implements two distinct trading strategies - Long and Short - each with its own configuration and behavior. Both strategies use the same general framework but with different parameters and thresholds optimized for their respective trading directions.

## Long Strategy (Buying dips)
The long strategy is designed to catch downward price movements and accumulate positions at lower prices.

### Long Position Management
```json
"long": {
  "reversal_protection": true,
  "directional_price_change_percent": true,
  "directional_minimum_price_change_percent": -5.0,
  "max_running_symbols": 7,
  "exchange_leverage": 10,
  "wallet_exposure_per_symbol": 500,
  "entry": {
    "initial_entry_quantity_in_usdt": 25
  }
}
```

- `reversal_protection`: Prevents entries when price direction reverses (checks if current price is lower than previous 1-minute candle close)
- `directional_price_change_percent`: Enables filtering by overall market direction
- `directional_minimum_price_change_percent`: Only enters when 24h price change is below -5% (downtrend confirmation)
- `max_running_symbols`: Can trade up to 7 symbols simultaneously
- `exchange_leverage`: Uses 10x leverage
- `wallet_exposure_per_symbol`: Maximum 500 USDT exposure per symbol
- `initial_entry_quantity_in_usdt`: Starts with 25 USDT initial position

### Long Entry Strategy
```json
"entry": {
  "min_ticks": 10,
  "price_change_interval_s": 7,
  "price_change_threshold": -0.0075
}
```

Long entry conditions:
- `min_ticks`: Requires minimum 10 price updates
- `price_change_interval_s`: Monitors price over 7-second windows
- `price_change_threshold`: Triggers on 0.75% price drops (-0.0075)

### Long Hovering DCA
```json
"hovering_dca": {
  "inner_layer": {
    "hover_distance": -0.0075,
    "hover_price_change_interval_s": 6,
    "hover_activation_distance_from_position_price": -0.0025,
    "dca_size_multiplier": 4.25
  },
  "outer_layer": {
    "hover_distance": -0.01,
    "hover_price_change_interval_s": 13,
    "hover_activation_distance_from_position_price": -0.1,
    "dca_size_multiplier": 4.55
  }
}
```

Two-layer DCA system for longs:
- Inner Layer (For positions < 50% max exposure):
  - Places buy orders 0.75% below current price
  - Updates every 6 seconds
  - Activates when price drops 0.25% below entry
  - Each DCA is 4.25x the previous order

- Outer Layer (For positions >= 50% max exposure):
  - Places buy orders 1% below current price
  - Updates every 13 seconds
  - Activates when price drops 10% below entry
  - Each DCA is 4.55x the previous order

### Long Take-Profit Management
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

Long take-profit strategy:
- Initial static take-profit at 1.5% above entry
- Activates trailing mechanism at 0.75% profit
- Updates every 5 seconds
- Places two take-profit orders that work together:
  - LIMIT sell order 0.35% above current price (takes profit immediately when price hits target)
  - STOP sell order 0.25% below current price (trailing take-profit to lock in gains as price moves up)

### How Long Strategy Works

1. Monitors for downward volatility
2. Entry Conditions:
   - Checks overall 24h price change is below -5% (if directional filter enabled)
   - Ensures price is not reversing (if reversal protection enabled)
   - Waits for 10 price ticks minimum
   - Looks for 0.75% drop within 7 seconds
   - Opens 25 USDT long position with MARKET order if all criteria met

3. DCA Management:
   - Activates hovering DCA system that continuously monitors price:
     - Small Positions (Inner Layer):
       - Every 6 seconds, if price is 0.25% below entry
       - Places dynamic buy orders 0.75% below current price
       - Orders are continuously refreshed for optimal entry
       - DCA size is 4.25x previous order
     - Larger Positions (Outer Layer):
       - Every 13 seconds, if price is 10% below entry
       - Places dynamic buy orders 1% below current price
       - Provides protection for deeper drawdowns
       - DCA size is 4.55x previous order

4. Exit Management:
   - Starts with fixed take-profit at 1.5% above entry
   - At 0.75% profit, switches to trailing take-profit:
     - LIMIT sell order 0.35% above current price
     - STOP protection order 0.25% below current price
     - Updates bounds every 5 seconds as price rises
   - All take-profit orders are for full position size

## Short Strategy (Short when price rises)
The short strategy is designed to open short positions when prices show significant upward movement, aiming to profit from potential reversals. It accumulates larger short positions at higher prices if the upward movement continues. This strategy is more conservative than its long counterpart, using stricter entry conditions and smaller position sizes.

### Short Position Management
```json
"short": {
  "reversal_protection": true,
  "directional_price_change_percent": true,
  "directional_minimum_price_change_percent": 25.0,
  "max_running_symbols": 3,
  "exchange_leverage": 10,
  "wallet_exposure_per_symbol": 200,
  "entry": {
    "initial_entry_quantity_in_usdt": 25
  }
}
```

- `reversal_protection`: Prevents entries when price direction reverses (checks if current price is higher than previous 1-minute candle close)
- `directional_price_change_percent`: Enables filtering by overall market direction
- `directional_minimum_price_change_percent`: Only enters when 24h price change is above 25% (strong uptrend confirmation)
- `max_running_symbols`: Limited to 3 simultaneous symbols
- `exchange_leverage`: Uses 10x leverage
- `wallet_exposure_per_symbol`: Maximum 200 USDT exposure per symbol
- `initial_entry_quantity_in_usdt`: Starts with 25 USDT initial position

### Short Entry Strategy
```json
"entry": {
  "min_ticks": 30,
  "price_change_interval_s": 13,
  "price_change_threshold": 0.02
}
```

Short entry conditions:
- `min_ticks`: Requires minimum 30 price updates
- `price_change_interval_s`: Monitors price over 13-second windows
- `price_change_threshold`: Triggers on 2% price rises (0.02)

### Short Hovering DCA
```json
"hovering_dca": {
  "inner_layer": {
    "hover_distance": 0.025,
    "hover_price_change_interval_s": 10,
    "hover_activation_distance_from_position_price": 0.05,
    "dca_size_multiplier": 4.25
  },
  "outer_layer": {
    "hover_distance": 0.025,
    "hover_price_change_interval_s": 10,
    "hover_activation_distance_from_position_price": 0.25,
    "dca_size_multiplier": 4.55
  }
}
```

Two-layer DCA system for shorts:
- Inner Layer (For positions < 50% max exposure):
  - Places sell orders 2.5% above current price
  - Updates every 10 seconds
  - Activates when price rises 5% above entry
  - Each DCA is 4.25x the previous order

- Outer Layer (For positions >= 50% max exposure):
  - Places sell orders 2.5% above current price
  - Updates every 10 seconds
  - Activates when price rises 25% above entry
  - Each DCA is 4.55x the previous order

### Short Take-Profit Management
```json
"trailing_tp": {
  "static_tp_distance": -0.015,
  "trailing_activation_distance_from_position_price": -0.0075,
  "trailing_tp_interval_s": 5,
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

Short take-profit strategy:
- Initial static take-profit at 1.5% below entry
- Activates trailing mechanism at 0.75% profit
- Updates every 5 seconds
- Places two take-profit orders that work together:
  - LIMIT buy order 0.35% below current price (takes profit immediately when price hits target)
  - STOP buy order 0.25% above current price (trailing take-profit to lock in gains as price moves down)

### How Short Strategy Works

1. Monitors for upward volatility
2. Entry Conditions:
   - Checks overall 24h price change is above 25% (if directional filter enabled)
   - Ensures price is not reversing (if reversal protection enabled)
   - Waits for 30 price ticks minimum
   - Looks for 2% rise within 13 seconds
   - Opens 25 USDT short position with MARKET order if all criteria met
   
3. DCA Management:
   - Activates hovering DCA system that continuously monitors price:
     - Small Positions (Inner Layer):
       - Every 10 seconds, if price is 5% above entry
       - Places dynamic sell orders 2.5% above current price
       - Orders are continuously refreshed for optimal entry
       - DCA size is 4.25x previous order
     - Larger Positions (Outer Layer):
       - Every 10 seconds, if price is 25% above entry
       - Places dynamic sell orders 2.5% above current price
       - Provides protection for stronger rallies
       - DCA size is 4.55x previous order

4. Exit Management:
   - Starts with fixed take-profit at 1.5% below entry
   - At 0.75% profit, switches to trailing take-profit:
     - STOP buy order 0.25% above current price
     - LIMIT buy order 0.35% below current price
     - Updates bounds every 5 seconds as price falls
   - All take-profit orders are for full position size

### Key Differences Between Long and Short Strategies

1. Position Management:
   - Longs: More aggressive with 7 max positions and 500 USDT exposure
   - Shorts: Conservative with 3 max positions and 200 USDT exposure

2. Directional Filtering:
   - Longs: Requires 24h price change below -5% (downtrend confirmation)
   - Shorts: Requires 24h price change above 25% (strong uptrend confirmation)

3. Entry Conditions:
   - Longs: Quicker entry (10 ticks, 7s window, 0.75% drop)
   - Shorts: Stricter entry (30 ticks, 13s window, 2% rise)

4. DCA Behavior:
   - Longs: More frequent updates on inner layer (6s vs 10s)
   - Shorts: Higher activation thresholds (5% and 25% vs 0.25% and 10%)

5. Take-Profit:
   - Both use similar mechanisms but inversed
   - Order types are swapped (LIMIT/STOP) for respective directions

6. Reversal Protection:
   - Both use 1-minute candle close comparisons
   - Longs: Only enter when price is lower than previous 1m candle close
   - Shorts: Only enter when price is higher than previous 1m candle close

## Risk Management

Aequify includes advanced risk management features designed to protect positions and automate profit-taking:

### Auto Hedge Strategy

The auto hedge feature provides automated position protection through two distinct strategies:

#### 1. Stuck Long Protection (STUCK_LONG_OPEN_SHORT)
Automatically creates hedge positions for stuck long trades by opening counterbalancing short positions.

Configuration:
```json
"auto_hedge": {
  "enabled": true,
  "position_check_interval_s": 5,
  "entry_strategy": {
    "activation_mode": "STUCK_LONG_OPEN_SHORT",
    "activate_when_stuck_position_quantity_exceeds_exposure": 0.5,
    "activation_distance_from_stuck_position_price": 0.05,
    "quantity_pct_from_stuck_position_quantity": 0.5
  },
  "exit_strategy": {
    "activation_mode": "ZERO_SUM"
  }
}
```

Activation conditions:
- Position value exceeds 50% of maximum wallet exposure
- Price drops 5% below entry price
- Creates a hedge short position of 50% of the long position size

Operation:
- Monitors long positions every 5 seconds
- When conditions are met, opens a MARKET short position
- Maintains the hedge until exit conditions are met

#### 2. Zero Sum Exit Strategy (ZERO_SUM)
Automatically manages and closes paired long-short positions when their combined PnL becomes positive.

Operation:
- Monitors paired long-short positions
- Calculates combined unrealized PnL for both positions
- When total PnL becomes positive, closes both positions using TAKE_PROFIT_MARKET orders
- Helps secure profits while minimizing losses from stuck positions

### Additional Risk Management Features

Aequify now includes full implementations of all previously planned risk management features:

#### Auto Profit Transfer

```json
"auto_profit_transfer": {
  "enabled": true,
  "target_wallet": "FUNDING",
  "daily_profit_pct_threshold": 5.0
}
```

Automatically transfers profits to your funding wallet when:
- Daily profit percentage exceeds the configured threshold (5.0%)
- Transfers excess profits to protect and secure earnings

#### Auto Reduce Stuck Position

```json
"auto_reduce_stuck_position": {
  "enabled": true,
  "unrealized_pct_activation_threshold": -30.0,
  "quantity_pct_to_reduce_from_position_quantity": 0.5,
  "reduced_unrealized_pct_activation_threshold": -40.0
}
```

Provides automated partial position reduction when:
- Unrealized loss exceeds 30% of position value
- Cuts position size by 50% to reduce exposure 
- Further reduces if losses reach 40% threshold

#### No Entry Only Exit

```json
"no_entry_only_exit": {
  "enabled": false
}
```

Emergency mode that:
- Prevents new position entries
- Allows existing positions to be closed
- Can be enabled during high market uncertainty or system maintenance


## Redis Configuration

The system uses Redis for state management:

```json
"redis": {
  "hostname": "redis",
  "port": 6379
}
```

Required for real-time data synchronization and position tracking.
