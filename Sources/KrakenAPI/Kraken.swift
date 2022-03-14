//
//  Kraken.swift
//  KrakenAPI
//
//  Created by Lukas Pistrol on 13.03.2022.
//  Copyright © 2022 Lukas Pistrol. All rights reserved.
//

import Foundation

/**
    Kraken REST API

    [See Reference here](https://docs.kraken.com/rest/)

    Requests:
    Request payloads are form-encoded (`Content-Type: application/x-www-form-urlencoded`), and all requests must specify a `User-Agent` in their headers.

    Responses:
    Responses are JSON encoded and contain one or two top-level keys (`result` and `error` for successful requests or those with warnings, or only error for failed or rejected requests)

    Error Details:
    HTTP status codes are generally not used by our API to convey information about the state of requests -- any errors or warnings are denoted in the error field of the response as described above. Status codes other than 200 indicate that there was an issue with the request reaching our servers.

    `error` messages follow the general format `<severity><category>:<error msg>`[`:add'l text`]

    - `severity` can be either `E` for error or `W` for warning
    - `category` can be one of `General`, `Auth`, `API`, `Query`, `Order`, `Trade`, `Funding`, or `Service`
    - `error msg` can be any text string that describes the reason for the error
*/
public struct Kraken {

	/// API Credentials for connecting to Kraken REST API
    public struct Credentials {
        var apiKey: String
        var privateKey: String

		/// API Keys can be created on [Kraken.com](https://kraken.com/u/security/api/)
		/// - Parameters:
		///   - key: The API Key
		///   - secret: The Private Key
        public init(apiKey: String, privateKey: String) {
			self.apiKey = apiKey
			self.privateKey = privateKey
        }
    }
    
    private let request: KrakenNetwork

	public init(credentials: Credentials) {
		request = KrakenNetwork(credentials: credentials)
	}

    // MARK: - Public methods

	// MARK: Server Time

    /// Get the server's time.
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getServerTime)
    public func serverTime(completion: @escaping KrakenNetwork.AsyncOperation) {
        request.getRequest(with: "Time", completion: completion)
    }

	/// Get the server's time.
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getServerTime)
	public func serverTime() async -> KrakenNetwork.AsyncResult {
		await request.getRequest(with: "Time")
	}

	// MARK: System Status

    /// Get the current system status or trading mode.
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getSystemStatus)
    public func systemStatus(completion: @escaping KrakenNetwork.AsyncOperation) {
        request.getRequest(with: "SystemStatus", completion: completion)
    }

	/// Get the current system status or trading mode.
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getSystemStatus)
	public func systemStatus() async -> KrakenNetwork.AsyncResult {
		await request.getRequest(with: "SystemStatus")
	}

	// MARK: Assets

    /// Get information about the assets that are available for deposit, withdrawal, trading and staking.
	///
	/// **Query Parameters:**
	/// - "asset": `String`
	/// - "aclass": `String`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getAssetInfo)
    public func assets(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.getRequest(with: "Assets", params: options, completion: completion)
    }

	/// Get information about the assets that are available for deposit, withdrawal, trading and staking.
	///
	/// **Query Parameters:**
	/// - "asset": `String`
	/// - "aclass": `String`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getAssetInfo)
	public func assets(options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		await request.getRequest(with: "Assets", params: options)
	}

	// MARK: Asset Pairs

    /// Get tradable asset pairs.
	///
	/// **Query Parameters:**
	/// - "pair": `String`
	/// - "info": `String` (optional)
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTradableAssetPairs)
    public func assetPairs(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.getRequest(with: "AssetPairs", params: options, completion: completion)
    }

	/// Get tradable asset pairs.
	///
	/// **Query Parameters:**
	/// - "pair": `String`
	/// - "info": `String` (optional)
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTradableAssetPairs)
	public func assetPairs(options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		await request.getRequest(with: "AssetPairs", params: options)
	}

	// MARK: Ticker
    
    /// Get Ticker Information.
    /// 
    /// Note: Today's prices start at midnight UTC
	///
	/// **Query Parameters:**
	/// - "pair": `String` (required)
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTickerInformation)
    public func ticker(pairs: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Ticker", params: optionsCopy, completion: completion)
    }

	/// Get Ticker Information.
	///
	/// Note: Today's prices start at midnight UTC
	///
	/// **Query Parameters:**
	/// - "pair": `String` (required)
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTickerInformation)
	public func ticker(pairs: [String], options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		var optionsCopy = options ?? [:]
		optionsCopy["pair"] = pairs.joined(separator: ",")
		return await request.getRequest(with: "Ticker", params: optionsCopy)
	}

	// MARK: OHLC

    /// Get OHLC Data
    /// 
    /// Note: the last entry in the OHLC array is for the current, not-yet-committed frame and will always be present, regardless of the value of `since`.
	///
	/// **Query Parameters:**
	/// - "pair": `String` (required)
	/// - "interval": `Int`
	/// - "since": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getOHLCData)
    public func ohlcData(pair: String, options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pair
        request.getRequest(with: "OHLC", params: optionsCopy, completion: completion)
    }

	/// Get OHLC Data
	///
	/// Note: the last entry in the OHLC array is for the current, not-yet-committed frame and will always be present, regardless of the value of `since`.
	///
	/// **Query Parameters:**
	/// - "pair": `String` (required)
	/// - "interval": `Int`
	/// - "since": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getOHLCData)
	public func ohlcData(pair: String, options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		var optionsCopy = options ?? [:]
		optionsCopy["pair"] = pair
		return await request.getRequest(with: "OHLC", params: optionsCopy)
	}

	// MARK: Order Book

    /// Get Order Book
	///
	/// **Query Parameters:**
	/// - "pair": `String` (required)
	/// - "count": `Int` [1 .. 500]
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getOrderBook)
    public func orderBook(pairs: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Depth", params: optionsCopy, completion: completion)
    }

	/// Get Order Book
	///
	/// **Query Parameters:**
	/// - "pair": `String` (required)
	/// - "count": `Int` [1 .. 500]
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getOrderBook)
	public func orderBook(pairs: [String], options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		var optionsCopy = options ?? [:]
		optionsCopy["pair"] = pairs.joined(separator: ",")
		return await request.getRequest(with: "Depth", params: optionsCopy)
	}

	// MARK: Trades
    
    /// Get Recent Trades
	///
	/// Returns the last 1000 trades by default
	///
	/// **Query Parameters:**
	/// - "pair": `String` (required)
	/// - "since": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getRecentTrades)
    public func trades(pairs: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Trades", params: optionsCopy, completion: completion)
    }

	/// Get Recent Trades
	///
	/// Returns the last 1000 trades by default
	///
	/// **Query Parameters:**
	/// - "pair": `String` (required)
	/// - "since": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getRecentTrades)
	public func trades(pairs: [String], options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		var optionsCopy = options ?? [:]
		optionsCopy["pair"] = pairs.joined(separator: ",")
		return await request.getRequest(with: "Trades", params: optionsCopy)
	}

	// MARK: Spread
    
    /// Get Recent Spreads
	///
	/// **Query Parameters:**
	/// - "pair": `String` (required)
	/// - "since": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getRecentSpreads)
    public func spread(pairs: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Spread", params: optionsCopy, completion: completion)
    }

	/// Get Recent Spreads
	///
	/// **Query Parameters:**
	/// - "pair": `String` (required)
	/// - "since": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getRecentSpreads)
	public func spread(pairs: [String], options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		var optionsCopy = options ?? [:]
		optionsCopy["pair"] = pairs.joined(separator: ",")
		return await request.getRequest(with: "Spread", params: optionsCopy)
	}
    
    // MARK: - Private methods

	// MARK: Balance
    
    /// Retrieve all cash balances, net of pending withdrawals.
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getAccountBalance)
    public func accountBalance(completion: @escaping KrakenNetwork.AsyncOperation) {
		request.postRequest(with: "Balance", params: [:], completion: completion)
    }

	/// Retrieve all cash balances, net of pending withdrawals.
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getAccountBalance)
	public func accountBalance() async -> KrakenNetwork.AsyncResult {
		await request.postRequest(with: "Balance", params: [:])
	}

	// MARK: Trade Balance
    
    /// Retrieve a summary of collateral balances, margin position valuations, equity and margin level.
	///
	/// **Query Parameters:**
	/// - "asset": `String`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTradeBalance)
    public func tradeBalance(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "TradeBalance", params: options, completion: completion)
    }

	/// Retrieve a summary of collateral balances, margin position valuations, equity and margin level.
	///
	/// **Query Parameters:**
	/// - "asset": `String`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTradeBalance)
	public func tradeBalance(options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		await request.postRequest(with: "TradeBalance", params: options)
	}

	// MARK: Open Orders

    /// Retrieve information about currently open orders.
	///
	/// **Query Parameters:**
	/// - "trades": `Bool`
	/// - "userref": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getOpenOrders)
    public func openOrders(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "OpenOrders", params: options, completion: completion)
    }

	/// Retrieve information about currently open orders.
	///
	/// **Query Parameters:**
	/// - "trades": `Bool`
	/// - "userref": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getOpenOrders)
	public func openOrders(options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		await request.postRequest(with: "OpenOrders", params: options)
	}

	// MARK: Closed Orders

    /// Retrieve information about orders that have been closed (filled or cancelled). 50 results are returned at a time, the most recent by default.
    /// 
    /// Note: If an order's tx ID is given for `start` or `end` time, the order's opening time (`opentm`) is used
	///
	/// **Query Parameters:**
	/// - "trades": `Bool`
	/// - "userref": `Int`
	/// - "start": `Int` (exclusive)
	/// - "end": `Int` (inclusive)
	/// - "ofs": `Int`
	/// - "closetime": `String` ["open", "close", "both"]
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getClosedOrders)
    public func closedOrders(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "ClosedOrders", params: options, completion: completion)
    }

	/// Retrieve information about orders that have been closed (filled or cancelled). 50 results are returned at a time, the most recent by default.
	///
	/// Note: If an order's tx ID is given for `start` or `end` time, the order's opening time (`opentm`) is used
	///
	/// **Query Parameters:**
	/// - "trades": `Bool`
	/// - "userref": `Int`
	/// - "start": `Int` (exclusive)
	/// - "end": `Int` (inclusive)
	/// - "ofs": `Int`
	/// - "closetime": `String` ["open", "close", "both"]
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getClosedOrders)
	public func closedOrders(options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		await request.postRequest(with: "ClosedOrders", params: options)
	}

	// MARK: Query Orders

    /// Retrieve information about specific orders.
	///
	/// **Query Parameters:**
	/// - "txid": `String` (required)
	/// - "trades": `Bool`
	/// - "userref": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getOrdersInfo)
    public func queryOrders(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "QueryOrders", params: options, completion: completion)
    }

	/// Retrieve information about specific orders.
	///
	/// **Query Parameters:**
	/// - "txid": `String` (required)
	/// - "trades": `Bool`
	/// - "userref": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getOrdersInfo)
	public func queryOrders(options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		await request.postRequest(with: "QueryOrders", params: options)
	}

	// MARK: Trades History
    
    /// Retrieve information about trades/fills. 50 results are returned at a time, the most recent by default.
    ///
    /// Unless otherwise stated, costs, fees, prices, and volumes are specified with the precision for the asset pair (`pair_decimals` and `lot_decimals`), not the individual assets' precision (`decimals`).
	///
	/// **Query Parameters:**
	/// - "type": `String` ["all", "any position", "closed position", "closing position", "no position"]
	/// - "trades": `Bool`
	/// - "start": `Int` (exclusive)
	/// - "end": `Int` (inclusive)
	/// - "ofs": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTadeHistory)
    public func tradesHistory(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "TradesHistory", params: options, completion: completion)
    }

	/// Retrieve information about trades/fills. 50 results are returned at a time, the most recent by default.
	///
	/// Unless otherwise stated, costs, fees, prices, and volumes are specified with the precision for the asset pair (`pair_decimals` and `lot_decimals`), not the individual assets' precision (`decimals`).
	///
	/// **Query Parameters:**
	/// - "type": `String` ["all", "any position", "closed position", "closing position", "no position"]
	/// - "trades": `Bool`
	/// - "start": `Int` (exclusive)
	/// - "end": `Int` (inclusive)
	/// - "ofs": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTadeHistory)
	public func tradesHistory(options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		await request.postRequest(with: "TradesHistory", params: options)
	}

	// MARK: Query Trades
    
    /// Retrieve information about specific trades/fills.
	///
	/// **Query Parameters:**
	/// - "txid": `String`
	/// - "trades": `Bool`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTradesInfo)
    public func queryTrades(ids: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["txid"] = ids.joined(separator: ",")
        request.postRequest(with: "QueryTrades", params: optionsCopy, completion: completion)
    }

	/// Retrieve information about specific trades/fills.
	///
	/// **Query Parameters:**
	/// - "txid": `String`
	/// - "trades": `Bool`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTradesInfo)
	public func queryTrades(ids: [String], options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		var optionsCopy = options ?? [:]
		optionsCopy["txid"] = ids.joined(separator: ",")
		return await request.postRequest(with: "QueryTrades", params: optionsCopy)
	}

	// MARK: Open Positions
    
    /// Get information about open margin positions.
	///
	/// **Query Parameters:**
	/// - "txid": `String`
	/// - "docalcs": `Bool`
	/// - "consolidation": `String`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getOpenPositions)
    public func openPositions(ids: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["txid"] = ids.joined(separator: ",")
        request.postRequest(with: "OpenPositions", params: optionsCopy, completion: completion)
    }

	/// Get information about open margin positions.
	///
	/// **Query Parameters:**
	/// - "txid": `String`
	/// - "docalcs": `Bool`
	/// - "consolidation": `String`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getOpenPositions)
	public func openPositions(ids: [String], options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		var optionsCopy = options ?? [:]
		optionsCopy["txid"] = ids.joined(separator: ",")
		return await request.postRequest(with: "OpenPositions", params: optionsCopy)
	}

	// MARK: Ledgers
    
    /// Retrieve information about ledger entries. 50 results are returned at a time, the most recent by default.
	///
	/// **Query Parameters:**
	/// - "asset": `String`
	/// - "aclass": `String`
	/// - "type": `String` ["all", "deposit", "withdrawal", "trade", "margin", "rollover", "credit", "transfer", "settled", "staking", "sale"]
	/// - "start": `Int`
	/// - "end": `Int`
	/// - "ofs": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getLedgers)
    public func ledgersInfo(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "Ledgers", params: options, completion: completion)
    }

	/// Retrieve information about ledger entries. 50 results are returned at a time, the most recent by default.
	///
	/// **Query Parameters:**
	/// - "asset": `String`
	/// - "aclass": `String`
	/// - "type": `String` ["all", "deposit", "withdrawal", "trade", "margin", "rollover", "credit", "transfer", "settled", "staking", "sale"]
	/// - "start": `Int`
	/// - "end": `Int`
	/// - "ofs": `Int`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getLedgers)
	public func ledgersInfo(options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		await request.postRequest(with: "Ledgers", params: options)
	}

	// MARK: Query Ledgers
    
    /// Retrieve information about specific ledger entries.
	///
	/// **Query Parameters:**
	/// - "id": `String`
	/// - "trades": `Bool`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getLedgersInfo)
    public func queryLedgers(ledgerIds: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["id"] = ledgerIds.joined(separator: ",")
        request.postRequest(with: "QueryLedgers", params: optionsCopy, completion: completion)
    }

	/// Retrieve information about specific ledger entries.
	///
	/// **Query Parameters:**
	/// - "id": `String`
	/// - "trades": `Bool`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getLedgersInfo)
	public func queryLedgers(ledgerIds: [String], options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		var optionsCopy = options ?? [:]
		optionsCopy["id"] = ledgerIds.joined(separator: ",")
		return await request.postRequest(with: "QueryLedgers", params: optionsCopy)
	}

	// MARK: Trade Volume
    
    /// Get Trade Volume
    ///
    /// Note: If an asset pair is on a maker/taker fee schedule, the taker side is given in `fees` and maker side in `fees_maker`. For pairs not on maker/taker, they will only be given in `fees`.
	///
	/// **Query Parameters:**
	/// - "pair": `String`
	/// - "fee-info": `Bool`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTradeVolume
    public func tradeVolume(pairs: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.postRequest(with: "TradeVolume", params: optionsCopy, completion: completion)
    }

	/// Get Trade Volume
	///
	/// Note: If an asset pair is on a maker/taker fee schedule, the taker side is given in `fees` and maker side in `fees_maker`. For pairs not on maker/taker, they will only be given in `fees`.
	///
	/// **Query Parameters:**
	/// - "pair": `String`
	/// - "fee-info": `Bool`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/getTradeVolume
	public func tradeVolume(pairs: [String], options: [String: String]? = nil) async -> KrakenNetwork.AsyncResult {
		var optionsCopy = options ?? [:]
		optionsCopy["pair"] = pairs.joined(separator: ",")
		return await request.postRequest(with: "TradeVolume", params: optionsCopy)
	}

	// MARK: - User Trading

	// MARK: Add Order

    /// Place a new order.
    ///
    /// Note: See the `AssetPairs` endpoint for details on the available trading pairs, their price and quantity precisions, order minimums, available leverage, etc.
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/addOrder)
    public func addOrder(options: [String: String], completion: @escaping KrakenNetwork.AsyncOperation) {
        let valuesNeeded = ["pair", "type", "orderType", "volume"]
        guard options.keys.contains(array: valuesNeeded) else {
            fatalError("Required options, not given. Input must include \(valuesNeeded)")
        }
        request.postRequest(with: "AddOrder", params: options, completion: completion)
    }

	/// Place a new order.
	///
	/// Note: See the `AssetPairs` endpoint for details on the available trading pairs, their price and quantity precisions, order minimums, available leverage, etc.
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/addOrder)
	public func addOrder(options: [String: String]) async -> KrakenNetwork.AsyncResult {
		let valuesNeeded = ["pair", "type", "orderType", "volume"]
		guard options.keys.contains(array: valuesNeeded) else {
			fatalError("Required options, not given. Input must include \(valuesNeeded)")
		}
		return await request.postRequest(with: "AddOrder", params: options)
	}

	// MARK: Cancel Order

    /// Cancel a particular open order (or set of open orders) by `txid` or `userref`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/cancelOrder)
    public func cancelOrder(ids: [String], completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy: [String: String] = [:]
        optionsCopy["txid"] = ids.joined(separator: ",")
        request.postRequest(with: "CancelOrder", params: optionsCopy, completion: completion)
    }

	/// Cancel a particular open order (or set of open orders) by `txid` or `userref`
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/cancelOrder)
	public func cancelOrder(ids: [String]) async -> KrakenNetwork.AsyncResult {
		var optionsCopy: [String: String] = [:]
		optionsCopy["txid"] = ids.joined(separator: ",")
		return await request.postRequest(with: "CancelOrder", params: optionsCopy)
	}

	// MARK: Cancel All Orders

    /// Cancel all open orders
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/cancelAllOrders)
    public func cancelAllOrders(completion: @escaping KrakenNetwork.AsyncOperation) {
		request.postRequest(with: "CancelAll", completion: completion)
    }

	/// Cancel all open orders
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/cancelAllOrders)
	public func cancelAllOrders() async -> KrakenNetwork.AsyncResult {
		await request.postRequest(with: "CancelAll")
	}

	// MARK: Cancel All Orders After

    /// Cancel All Orders After X
    /// 
    /// CancelAllOrdersAfter provides a "Dead Man's Switch" mechanism to protect the client from network malfunction, extreme latency or unexpected matching engine downtime. The client can send a request with a timeout (in seconds), that will start a countdown timer which will cancel all client orders when the timer expires. The client has to keep sending new requests to push back the trigger time, or deactivate the mechanism by specifying a timeout of 0. If the timer expires, all orders are cancelled and then the timer remains disabled until the client provides a new (non-zero) timeout.
    ///
    ///The recommended use is to make a call every 15 to 30 seconds, providing a timeout of 60 seconds. This allows the client to keep the orders in place in case of a brief disconnection or transient delay, while keeping them safe in case of a network breakdown. It is also recommended to disable the timer ahead of regularly scheduled trading engine maintenance (if the timer is enabled, all orders will be cancelled when the trading engine comes back from downtime - planned or otherwise).
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/cancelAllOrdersAfter)
    public func cancelAllAfter(timeout: Int, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy: [String: String] = [:]
        optionsCopy["timeout"] = "\(timeout)"
        request.postRequest(with: "CancelAllOrdersAfter", params: optionsCopy, completion: completion)
    }

	/// Cancel All Orders After X
	///
	/// CancelAllOrdersAfter provides a "Dead Man's Switch" mechanism to protect the client from network malfunction, extreme latency or unexpected matching engine downtime. The client can send a request with a timeout (in seconds), that will start a countdown timer which will cancel all client orders when the timer expires. The client has to keep sending new requests to push back the trigger time, or deactivate the mechanism by specifying a timeout of 0. If the timer expires, all orders are cancelled and then the timer remains disabled until the client provides a new (non-zero) timeout.
	///
	///The recommended use is to make a call every 15 to 30 seconds, providing a timeout of 60 seconds. This allows the client to keep the orders in place in case of a brief disconnection or transient delay, while keeping them safe in case of a network breakdown. It is also recommended to disable the timer ahead of regularly scheduled trading engine maintenance (if the timer is enabled, all orders will be cancelled when the trading engine comes back from downtime - planned or otherwise).
	///
	/// [API Reference](https://docs.kraken.com/rest/#operation/cancelAllOrdersAfter)
	public func cancelAllAfter(timeout: Int) async -> KrakenNetwork.AsyncResult {
		var optionsCopy: [String: String] = [:]
		optionsCopy["timeout"] = "\(timeout)"
		return await request.postRequest(with: "CancelAllOrdersAfter", params: optionsCopy)
	}
    
}
