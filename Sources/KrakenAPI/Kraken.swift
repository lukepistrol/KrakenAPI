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

    ### Requests:
    Request payloads are form-encoded (`Content-Type: application/x-www-form-urlencoded`), and all requests must specify a `User-Agent` in their headers.

    ### Responses:
    Responses are JSON encoded and contain one or two top-level keys (`result` and `error` for successful requests or those with warnings, or only error for failed or rejected requests)

    ### Error Details:
    HTTP status codes are generally not used by our API to convey information about the state of requests -- any errors or warnings are denoted in the error field of the response as described above. Status codes other than 200 indicate that there was an issue with the request reaching our servers.

    `error` messages follow the general format `<severity><category>:<error msg>`[`:add'l text`]

    - `severity` can be either `E` for error or `W` for warning
    - `category` can be one of `General`, `Auth`, `API`, `Query`, `Order`, `Trade`, `Funding`, or `Service`
    - `error msg` can be any text string that describes the reason for the error
*/
public struct Kraken {

	/// API Credentials for connecting to Kraken REST API
    public struct Credentials {
		/// The API Key
        internal var apiKey: String

		/// The Private Key (Secret)
        internal var privateKey: String

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
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getServerTime)
    public func serverTime(completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
        request.getRequest(with: "Time", completion: completion)
    }

	/// Get the server's time.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getServerTime)
	public func serverTime() async -> KrakenNetwork.KrakenResult {
		await request.getRequest(with: "Time")
	}

	// MARK: System Status

    /// Get the current system status or trading mode.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getSystemStatus)
    public func systemStatus(completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
        request.getRequest(with: "SystemStatus", completion: completion)
    }

	/// Get the current system status or trading mode.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getSystemStatus)
	public func systemStatus() async -> KrakenNetwork.KrakenResult {
		await request.getRequest(with: "SystemStatus")
	}

	// MARK: Assets

    /// Get information about the assets that are available for deposit, withdrawal, trading and staking.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getAssetInfo)
	///
	/// - Parameters:
	///   - assets: List of assets to get info on (Example: "XBT, "ETH")
	///   - aclass: Asset class (optional, Default: "currency")
	///
    public func assets(assets: [String]? = nil, aclass: String = "currency", completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		if let assets = assets {
			options["asset"] = assets.joined(separator: ",")
		}
		options["aclass"] = aclass
        request.getRequest(with: "Assets", params: options, completion: completion)
    }

	/// Get information about the assets that are available for deposit, withdrawal, trading and staking.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getAssetInfo)
	///
	/// - Parameters:
	///   - assets: List of assets to get info on (Example: "XBT, "ETH")
	///   - aclass: Asset class (optional, Default: "currency")
	///
	public func assets(assets: [String]? = nil, aclass: String = "currency") async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		if let assets = assets {
			options["asset"] = assets.joined(separator: ",")
		}
		options["aclass"] = aclass
		return await request.getRequest(with: "Assets", params: options)
	}

	// MARK: Asset Pairs

    /// Get tradable asset pairs.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getTradableAssetPairs)
	///
	/// - Parameters:
	///   - pairs: Asset pairs to get data for (Example: "XBTUSD","XETHXXBT")
	///   - info: Info to retreive (Default: "info") ["info", "leverage", "fees", "margin"]
	///
	public func assetPairs(pairs: [String]? = nil, info: AssetPairInfo = .info, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		if let pairs = pairs {
			options["pair"] = pairs.joined(separator: ",")
		}
		options["info"] = info.rawValue
        request.getRequest(with: "AssetPairs", params: options, completion: completion)
    }

	/// Get tradable asset pairs.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getTradableAssetPairs)
	///
	/// - Parameters:
	///   - pairs: Asset pairs to get data for (Example: "XBTUSD","XETHXXBT")
	///   - info: Info to retreive (Default: "info") ["info", "leverage", "fees", "margin"]
	///
	public func assetPairs(pairs: [String]? = nil, info: AssetPairInfo = .info) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		if let pairs = pairs {
			options["pair"] = pairs.joined(separator: ",")
		}
		options["info"] = info.rawValue
		return await request.getRequest(with: "AssetPairs", params: options)
	}

	// MARK: Ticker
    
    /// Get Ticker Information.
    /// 
    /// Note: Today's prices start at midnight UTC
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getTickerInformation)
	///
	/// - Parameter pair: Asset pair to get data for (Example: "XBTUSD")
	///
    public func ticker(pair: String, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["pair"] = pair
        request.getRequest(with: "Ticker", params: options, completion: completion)
    }

	/// Get Ticker Information.
	///
	/// Note: Today's prices start at midnight UTC
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getTickerInformation)
	///
	/// - Parameter pair: Asset pair to get data for (Example: "XBTUSD")
	///
	public func ticker(pair: String) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["pair"] = pair
		return await request.getRequest(with: "Ticker", params: options)
	}

	// MARK: OHLC

    /// Get OHLC Data
    /// 
    /// Note: the last entry in the OHLC array is for the current, not-yet-committed frame and will always be present, regardless of the value of `since`.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getOHLCData)
	///
	/// - Parameters:
	///   - pair: Asset pair to get data for (Example: "XBTUSD")
	///   - interval: Time frame interval in minutes (Only [1, 5, 15, 30, 60, 240, 1440, 10080, 21600] allowed)
	///   - since: Return ommitted OHLC data since given ID (Example: 1548111600)
	///
	public func ohlcData(pair: String, interval: OHLCInterval = .i1min, since: Int? = nil, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["pair"] = pair
		options["interval"] = interval.rawValue
		if let since = since {
			options["since"] = "\(since)"
		}
        request.getRequest(with: "OHLC", params: options, completion: completion)
    }

	/// Get OHLC Data
	///
	/// Note: the last entry in the OHLC array is for the current, not-yet-committed frame and will always be present, regardless of the value of `since`.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getOHLCData)
	///
	/// - Parameters:
	///   - pair: Asset pair to get data for (Example: "XBTUSD")
	///   - interval: Time frame interval in minutes (Only [1, 4, 15, 30, 60, 240, 1440, 10080, 21600] allowed)
	///   - since: Return ommitted OHLC data since given ID (Example: 1548111600)
	///
	public func ohlcData(pair: String, interval: OHLCInterval = .i1min, since: Int? = nil) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["pair"] = pair
		options["interval"] = interval.rawValue
		if let since = since {
			options["since"] = "\(since)"
		}
		return await request.getRequest(with: "OHLC", params: options)
	}

	// MARK: Order Book

	/// Get Order Book
	///
	///  [See API Reference](https://docs.kraken.com/rest/#operation/getOrderBook)
	///
	/// - Parameters:
	///   - pair: Asset pair to get data for (Example: "XBTUSD")
	///   - count: maximum number of asks/bids (Default: 100)
	///
	public func orderBook(pair: String, count: Int = 100, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
        options["pair"] = pair
		options["count"] = "\(count)"
        request.getRequest(with: "Depth", params: options, completion: completion)
    }

	/// Get Order Book
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getOrderBook)
	///
	/// - Parameters:
	///   - pair: Asset pair to get data for (Example: "XBTUSD")
	///   - count: maximum number of asks/bids (Default: 100)
	///
	public func orderBook(pair: String, count: Int = 100) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["pair"] = pair
		options["count"] = "\(count)"
		return await request.getRequest(with: "Depth", params: options)
	}

	// MARK: Trades
    
    /// Get Recent Trades
	///
	/// Returns the last 1000 trades by default
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getRecentTrades)
	///
	/// - Parameters:
	///   - pair: Asset pair to get data for (Example: "XBTUSD")
	///   - since: Unix timestamp as `Int` (Example: 1616663618)
	///
    public func trades(pair: String, since: Int? = nil, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["pair"] = pair
		if let since = since {
			options["since"] = "\(since)"
		}
        request.getRequest(with: "Trades", params: options, completion: completion)
    }

	/// Get Recent Trades
	///
	/// Returns the last 1000 trades by default
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getRecentTrades)
	///
	/// - Parameters:
	///   - pair: Asset pair to get data for (Example: "XBTUSD")
	///   - since: Unix timestamp as `Int` (Example: 1616663618)
	///
	public func trades(pair: String, since: Int? = nil) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["pair"] = pair
		if let since = since {
			options["since"] = "\(since)"
		}
		return await request.getRequest(with: "Trades", params: options)
	}

	// MARK: Spread
    
    /// Get Recent Spreads
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getRecentSpreads)
	///
	/// - Parameters:
	///   - pair: Asset pair to get data for (Example: "XBTUSD")
	///   - since: Unix timestamp as `Int` (Example: 1616663618)
	///
	public func spread(pair: String, since: Int? = nil, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["pair"] = pair
		if let since = since {
			options["since"] = "\(since)"
		}
        request.getRequest(with: "Spread", params: options, completion: completion)
    }

	/// Get Recent Spreads
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getRecentSpreads)
	///
	/// - Parameters:
	///   - pair: Asset pair to get data for (Example: "XBTUSD")
	///   - since: Unix timestamp as `Int` (Example: 1616663618)
	///
	public func spread(pair: String, since: Int? = nil) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["pair"] = pair
		if let since = since {
			options["since"] = "\(since)"
		}
		return await request.getRequest(with: "Spread", params: options)
	}
    
    // MARK: - Private methods

	// MARK: Balance
    
    /// Retrieve all cash balances, net of pending withdrawals.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getAccountBalance)
	///
    public func accountBalance(completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		request.postRequest(with: "Balance", completion: completion)
    }

	/// Retrieve all cash balances, net of pending withdrawals.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getAccountBalance)
	///
	public func accountBalance() async -> KrakenNetwork.KrakenResult {
		await request.postRequest(with: "Balance")
	}

	// MARK: Trade Balance
    
	/// Retrieve a summary of collateral balances, margin position valuations, equity and margin level.
	///
	///  [See API Reference](https://docs.kraken.com/rest/#operation/getTradeBalance)
	///
	/// - Parameters:
	///   - asset: Base asset used to determine balance (Default: "ZUSD")
	///
    public func tradeBalance(asset: String = "ZUSD", completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["asset"] = asset
        request.postRequest(with: "TradeBalance", params: options, completion: completion)
    }

	/// Retrieve a summary of collateral balances, margin position valuations, equity and margin level.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getTradeBalance)
	///
	/// - Parameters:
	///   - asset: Base asset used to determine balance (Default: "ZUSD")
	///
	public func tradeBalance(asset: String = "ZUSD") async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["asset"] = asset
		return await request.postRequest(with: "TradeBalance", params: options)
	}

	// MARK: Open Orders

	/// Retrieve information about currently open orders.
	///
	///  [See API Reference](https://docs.kraken.com/rest/#operation/getOpenOrders)
	///
	/// - Parameters:
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///   - userref: Restrict results to given user reference id
	///
	public func openOrders(trades: Bool = false, userref: Int? = nil, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["trades"] = "\(trades)"
		if let userref = userref {
			options["userref"] = "\(userref)"
		}
        request.postRequest(with: "OpenOrders", params: options, completion: completion)
    }

	/// Retrieve information about currently open orders.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getOpenOrders)
	///
	/// - Parameters:
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///   - userref: Restrict results to given user reference id
	///
	public func openOrders(trades: Bool = false, userref: Int? = nil) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["trades"] = "\(trades)"
		if let userref = userref {
			options["userref"] = "\(userref)"
		}
		return await request.postRequest(with: "OpenOrders", params: options)
	}

	// MARK: Closed Orders

	/// Retrieve information about orders that have been closed (filled or cancelled). 50 results are returned at a time, the most recent by default.
	///
	/// Note: If an order's tx ID is given for `start` or `end` time, the order's opening time (`opentm`) is used
	///
	///  [See API Reference](https://docs.kraken.com/rest/#operation/getClosedOrders)
	///
	/// - Parameters:
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///   - userref: Restrict results to given user reference id
	///   - start: Starting unix timestamp or order tx ID of results (exclusive)
	///   - end: Ending unix timestamp or order tx ID of results (inclusive)
	///   - ofs: Result offset for pagination
	///   - closetime: Which time to use to search (Default: "both") ["both", "open", "close"]
	///
	public func closedOrders(trades: Bool = false, userref: Int? = nil, start: Int? = nil, end: Int? = nil, ofs: Int? = nil, closetime: ClosedOrdersTime = .both, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["trades"] = "\(trades)"
		if let userref = userref {
			options["userref"] = "\(userref)"
		}
		if let start = start {
			options["start"] = "\(start)"
		}
		if let end = end {
			options["end"] = "\(end)"
		}
		if let ofs = ofs {
			options["ofs"] = "\(ofs)"
		}
		options["closetime"] = closetime.rawValue
        request.postRequest(with: "ClosedOrders", params: options, completion: completion)
    }

	/// Retrieve information about orders that have been closed (filled or cancelled). 50 results are returned at a time, the most recent by default.
	///
	/// Note: If an order's tx ID is given for `start` or `end` time, the order's opening time (`opentm`) is used
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getClosedOrders)
	///
	/// - Parameters:
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///   - userref: Restrict results to given user reference id
	///   - start: Starting unix timestamp or order tx ID of results (exclusive)
	///   - end: Ending unix timestamp or order tx ID of results (inclusive)
	///   - ofs: Result offset for pagination
	///   - closetime: Which time to use to search (Default: "both") ["both", "open", "close"]
	///
	public func closedOrders(trades: Bool = false, userref: Int? = nil, start: Int? = nil, end: Int? = nil, ofs: Int? = nil, closetime: ClosedOrdersTime = .both) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["trades"] = "\(trades)"
		if let userref = userref {
			options["userref"] = "\(userref)"
		}
		if let start = start {
			options["start"] = "\(start)"
		}
		if let end = end {
			options["end"] = "\(end)"
		}
		if let ofs = ofs {
			options["ofs"] = "\(ofs)"
		}
		options["closetime"] = closetime.rawValue
		return await request.postRequest(with: "ClosedOrders", params: options)
	}

	// MARK: Query Orders

	/// Retrieve information about specific orders.
	///
	///  [See API Reference](https://docs.kraken.com/rest/#operation/getOrdersInfo)
	///
	/// - Parameters:
	///   - txids: List of transaction IDs to query info about (50 maximum)
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///   - userref: Restrict results to given user reference id
	///
	public func queryOrders(txids: [String], trades: Bool = false, userref: Int? = nil, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["txid"] = txids.joined(separator: ",")
		options["trades"] = "\(trades)"
		if let userref = userref {
			options["userref"] = "\(userref)"
		}
        request.postRequest(with: "QueryOrders", params: options, completion: completion)
    }

	/// Retrieve information about specific orders.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getOrdersInfo)
	///
	/// - Parameters:
	///   - txids: List of transaction IDs to query info about (50 maximum)
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///   - userref: Restrict results to given user reference id
	///
	public func queryOrders(txids: [String], trades: Bool = false, userref: Int? = nil) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["txid"] = txids.joined(separator: ",")
		options["trades"] = "\(trades)"
		if let userref = userref {
			options["userref"] = "\(userref)"
		}
		return await request.postRequest(with: "QueryOrders", params: options)
	}

	// MARK: Trades History
    
	/// Retrieve information about trades/fills. 50 results are returned at a time, the most recent by default.
	///
	/// Unless otherwise stated, costs, fees, prices, and volumes are specified with the precision for the asset pair (`pair_decimals` and `lot_decimals`), not the individual assets' precision (`decimals`).
	///
	///  [See API Reference](https://docs.kraken.com/rest/#operation/getTadeHistory)
	///
	/// - Parameters:
	///   - type: Type of trade (Default: "all")  ["all", "any position", "closed position", "closing position", "no position"]
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///   - start: Starting unix timestamp or order tx ID of results (exclusive)
	///   - end: Ending unix timestamp or order tx ID of results (inclusive)
	///   - ofs: Result offset for pagination
	///
	public func tradesHistory(type: TradesHistoryType = .all, trades: Bool = false, start: Int? = nil, end: Int? = nil, ofs: Int? = nil, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["type"] = type.rawValue
		options["trades"] = "\(trades)"
		if let start = start {
			options["start"] = "\(start)"
		}
		if let end = end {
			options["end"] = "\(end)"
		}
		if let ofs = ofs {
			options["ofs"] = "\(ofs)"
		}
        request.postRequest(with: "TradesHistory", params: options, completion: completion)
    }

	/// Retrieve information about trades/fills. 50 results are returned at a time, the most recent by default.
	///
	/// Unless otherwise stated, costs, fees, prices, and volumes are specified with the precision for the asset pair (`pair_decimals` and `lot_decimals`), not the individual assets' precision (`decimals`).
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getTadeHistory)
	///
	/// - Parameters:
	///   - type: Type of trade (Default: "all")  ["all", "any position", "closed position", "closing position", "no position"]
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///   - start: Starting unix timestamp or order tx ID of results (exclusive)
	///   - end: Ending unix timestamp or order tx ID of results (inclusive)
	///   - ofs: Result offset for pagination
	///
	public func tradesHistory(type: TradesHistoryType = .all, trades: Bool = false, start: Int? = nil, end: Int? = nil, ofs: Int? = nil) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["type"] = type.rawValue
		options["trades"] = "\(trades)"
		if let start = start {
			options["start"] = "\(start)"
		}
		if let end = end {
			options["end"] = "\(end)"
		}
		if let ofs = ofs {
			options["ofs"] = "\(ofs)"
		}
		return await request.postRequest(with: "TradesHistory", params: options)
	}

	// MARK: Query Trades
    
    /// Retrieve information about specific trades/fills.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getTradesInfo)
	///
	/// - Parameters:
	///   - txids: List of transaction IDs to query info about (20 maximum)
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///
    public func queryTrades(txids: [String]? = nil, trades: Bool = false, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		if let txids = txids {
			options["txid"] = txids.joined(separator: ",")
		}
		options["trades"] = "\(trades)"
        request.postRequest(with: "QueryTrades", params: options, completion: completion)
    }

	/// Retrieve information about specific trades/fills.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getTradesInfo)
	///
	/// - Parameters:
	///   - txids: List of transaction IDs to query info about (20 maximum)
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///
	public func queryTrades(txids: [String]? = nil, trades: Bool = false) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		if let txids = txids {
			options["txid"] = txids.joined(separator: ",")
		}
		options["trades"] = "\(trades)"
		return await request.postRequest(with: "QueryTrades", params: options)
	}

	// MARK: Open Positions
    
	/// Get information about open margin positions.
	///
	///  [See API Reference](https://docs.kraken.com/rest/#operation/getOpenPositions)
	///
	/// - Parameters:
	///   - txids: List of txids to limit output to
	///   - docalcs: Whether to include P&L calculations (Default: false)
	///   - consolidation: Consolidate positions by market/pair (Default: "market")
	///
	public func openPositions(txids: [String]? = nil, docalcs: Bool = false, consolidation: OpenPositionConsolidation = .market, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		if let txids = txids {
			options["txid"] = txids.joined(separator: ",")
		}
		options["docalcs"] = "\(docalcs)"
		options["consolidation"] = consolidation.rawValue
        request.postRequest(with: "OpenPositions", params: options, completion: completion)
    }

	/// Get information about open margin positions.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getOpenPositions)
	///
	/// - Parameters:
	///   - txids: List of txids to limit output to
	///   - docalcs: Whether to include P&L calculations (Default: false)
	///   - consolidation: Consolidate positions by market/pair (Default: "market")
	///
	public func openPositions(txids: [String]? = nil, docalcs: Bool = false, consolidation: OpenPositionConsolidation = .market) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		if let txids = txids {
			options["txid"] = txids.joined(separator: ",")
		}
		options["docalcs"] = "\(docalcs)"
		options["consolidation"] = consolidation.rawValue
		return await request.postRequest(with: "OpenPositions", params: options)
	}

	// MARK: Ledgers
    
    /// Retrieve information about ledger entries. 50 results are returned at a time, the most recent by default.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getLedgers)
	///
	/// - Parameters:
	///   - asset: List of assets to restrict output to (Default: "all")
	///   - aclass: Asset class (Default: "currency")
	///   - type: Type of ledger to retrieve (Default: "all") ["all", "deposit", "withdrawal", "trade", "margin", "rollover", "credit", "transfer", "settled", "staking", "sale"]
	///   - start: Starting unix timestamp or ledger ID of results (exclusive)
	///   - end: Ending unix timestamp or ledger ID of results (inclusive)
	///   - ofs: Result offset for pagination
	///
	public func ledgersInfo(asset: [String] = ["all"], aclass: String = "currency", type: LedgerType = .all, start: Int? = nil, end: Int? = nil, ofs: Int? = nil, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["asset"] = asset.joined(separator: ",")
		options["aclass"] = aclass
		options["type"] = type.rawValue
		if let start = start {
			options["start"] = "\(start)"
		}
		if let end = end {
			options["end"] = "\(end)"
		}
		if let ofs = ofs {
			options["ofs"] = "\(ofs)"
		}
        request.postRequest(with: "Ledgers", params: options, completion: completion)
    }

	/// Retrieve information about ledger entries. 50 results are returned at a time, the most recent by default.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getLedgers)
	///
	/// - Parameters:
	///   - asset: List of assets to restrict output to (Default: "all")
	///   - aclass: Asset class (Default: "currency")
	///   - type: Type of ledger to retrieve (Default: "all") ["all", "deposit", "withdrawal", "trade", "margin", "rollover", "credit", "transfer", "settled", "staking", "sale"]
	///   - start: Starting unix timestamp or ledger ID of results (exclusive)
	///   - end: Ending unix timestamp or ledger ID of results (inclusive)
	///   - ofs: Result offset for pagination
	///
	public func ledgersInfo(asset: [String] = ["all"], aclass: String = "currency", type: LedgerType = .all, start: Int? = nil, end: Int? = nil, ofs: Int? = nil) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["asset"] = asset.joined(separator: ",")
		options["aclass"] = aclass
		options["type"] = type.rawValue
		if let start = start {
			options["start"] = "\(start)"
		}
		if let end = end {
			options["end"] = "\(end)"
		}
		if let ofs = ofs {
			options["ofs"] = "\(ofs)"
		}
		return await request.postRequest(with: "Ledgers", params: options)
	}

	// MARK: Query Ledgers
    
    /// Retrieve information about specific ledger entries.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getLedgersInfo)
	///
	/// - Parameters:
	///   - ids: List of ledger IDs to query info about (20 maximum)
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///
    public func queryLedgers(ids: [String]? = nil, trades: Bool = false, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		if let ids = ids {
			options["id"] = ids.joined(separator: ",")
		}
		options["trades"] = "\(trades)"
        request.postRequest(with: "QueryLedgers", params: options, completion: completion)
    }

	/// Retrieve information about specific ledger entries.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getLedgersInfo)
	///
	/// - Parameters:
	///   - ids: List of ledger IDs to query info about (20 maximum)
	///   - trades: Whether or not to include trades related to position in output (Default: false)
	///
	public func queryLedgers(ids: [String]? = nil, trades: Bool = false) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		if let ids = ids {
			options["id"] = ids.joined(separator: ",")
		}
		options["trades"] = "\(trades)"
		return await request.postRequest(with: "QueryLedgers", params: options)
	}

	// MARK: Trade Volume
    
	/// Get Trade Volume
	///
	/// Note: If an asset pair is on a maker/taker fee schedule, the taker side is given in `fees` and maker side in `fees_maker`. For pairs not on maker/taker, they will only be given in `fees`.
	///
	///  [See API Reference](https://docs.kraken.com/rest/#operation/getTradeVolume
	///
	/// - Parameters:
	///   - pairs: Asset pairs to get data for (Example: "XBTUSD")
	///   - feeInfo: Whether or not to include fee info in results (optional)
	///
	public func tradeVolume(pairs: [String], feeInfo: Bool? = nil, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["pair"] = pairs.joined(separator: ",")
		if let feeInfo = feeInfo {
			options["fee-info"] = "\(feeInfo)"
		}
        request.postRequest(with: "TradeVolume", params: options, completion: completion)
    }

	/// Get Trade Volume
	///
	/// Note: If an asset pair is on a maker/taker fee schedule, the taker side is given in `fees` and maker side in `fees_maker`. For pairs not on maker/taker, they will only be given in `fees`.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/getTradeVolume
	///
	/// - Parameters:
	///   - pairs: Asset pairs to get data for (Example: "XBTUSD")
	///   - feeInfo: Whether or not to include fee info in results (optional)
	///
	public func tradeVolume(pairs: [String], feeInfo: Bool? = nil) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["pair"] = pairs.joined(separator: ",")
		if let feeInfo = feeInfo {
			options["fee-info"] = "\(feeInfo)"
		}
		return await request.postRequest(with: "TradeVolume", params: options)
	}

	// MARK: - User Trading

	// MARK: Add Order

    /// Place a new order.
    ///
    /// Note: See the `AssetPairs` endpoint for details on the available trading pairs, their price and quantity precisions, order minimums, available leverage, etc.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/addOrder)
	///
	/// - Parameters:
	///   - orderType: Order Type ["market", "limit", "stop-loss", "take-profit", "stop-loss-limit", "take-profit-limit", "settle-position"]
	///   - type: Order Direction ["buy", "sell"]
	///   - pair: Asset pair `id` or `altname`
	///   - volume: Order quantity in terms of the base asset (Note: Volume can be specified as `0` for closing margin orders to automatically fill the requisite quantity)
	///   - price: Price (**Limit price** for `limit` orders, **Trigger price** for `stop-loss`, `stop-loss-limit`, `take-profit` and `take-profit-limit` orders)
	///   - price2: Secondary Price (**Limit price** for `stop-loss-limit` and `take-profit-limit` orders) **Note**: Either price or price2 can be preceded by +, -, or # to specify the order price as an offset relative to the last traded price. + adds the amount to, and - subtracts the amount from the last traded price. # will either add or subtract the amount to the last traded price, depending on the direction and order type used. Relative prices can be suffixed with a % to signify the relative amount as a percentage.
	///   - trigger: Price signal used to trigger `stop-loss`, `stop-loss-limit`, `take-profit` and `take-profit-limit` orders. (Default: "last") ["index", "last"]
	///   - leverage: Amount of lerverage desired (Default: "none")
	///   - oflags: List of order flags (`post`: post-only order (order type = limit), `fcib`: prefer fee in base currency, `gciq`: prefer fee in quote currency, `nompp`: disable market price protection for market orders
	///   - timeinforce: Time-in-force of the order to specify how long it should remain in the order book before being cancelled. **GTC** (Good-'til-cancelled) is default if the parameter is omitted. **IOC** (immediate-or-cancel) will immediately execute the amount possible and cancel any remaining balance rather than resting in the book. **GTD** (good-'til-date), if specified, must coincide with a desired `expiretm`. (Default: "GTC") ["GTC", "IOC", "GTD"]
	///   - starttm: Scheduled start time. Can be specified as an absolute timestamp or as a number of seconds in the future. (`0`: now (default), `+<n>`: schedule start time  seconds from now, `<n>`: unix timestamp of start time
	///   - expiretm: Expiration time (`0`: no expiration (default), `+<n>`: expire  seconds from now, `<n>`: unix timestamp of expiration time
	///   - closeOrdertype: Conditional close order type. ["limit", "stop-loss", "take-profit", "stop-loss-limit", "take-profit-limit"]
	///   - closePrice: Conditional close order `price`
	///   - closePrice2: Conditional close order `price2`
	///   - deadline: RFC3339 timestamp (e.g. 2021-04-01T00:18:45Z) after which the matching engine should reject the new order request, in presence of latency or order queueing. min now() + 2 seconds, max now() + 60 seconds.
	///   - validate: Validate inputs only. Do not submit order.
	///   - userref: User reference id. `userref` is an optional user-specified integer id that can be associated with any number of orders. Many clients choose a `userref` corresponding to a unique integer id generated by their systems (e.g. a timestamp). However, because we don't enforce uniqueness on our side, it can also be used to easily group orders by pair, side, strategy, etc. This allows clients to more readily cancel or query information about orders in a particular group, with fewer API calls by using `userref` instead of our `txid`, where supported.
	///
	public func addOrder(orderType: OrderType,
						 direction: OrderDirection,
						 pair: String,
						 volume: String? = nil,
						 price: String? = nil,
						 price2: String? = nil,
						 trigger: OrderTrigger = .last,
						 leverage: String? = nil,
						 oflags: [OrderFlag]? = nil,
						 timeinforce: TimeInForceType = .GTC,
						 starttm: String = "0",
						 expiretm: String = "0",
						 closeOrdertype: CloseOrderType? = nil,
						 closePrice: String? = nil,
						 closePrice2: String? = nil,
						 deadline: String? = nil,
						 validate: Bool = false,
						 userref: Int? = nil,
						 completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
		options["ordertype"] = orderType.rawValue
		options["type"] = direction.rawValue
		options["trigger"] = trigger.rawValue
		options["timeinforce"] = timeinforce.rawValue
		options["starttm"] = starttm
		options["expiretm"] = expiretm
		options["validate"] = "\(validate)"

		if let volume = volume {
			options["volume"] = volume
		}
		if let price = price {
			options["price"] = price
		}
		if let price2 = price2 {
			options["price2"] = price2
		}
		if let leverage = leverage {
			options["leverage"] = leverage
		}
		if let oflags = oflags {
			options["oflags"] = oflags.map { $0.rawValue }.joined(separator: ",")
		}
		if let closeOrdertype = closeOrdertype {
			options["close[ordertype]"] = closeOrdertype.rawValue
		}
		if let closePrice = closePrice {
			options["close[price]"] = closePrice
		}
		if let closePrice2 = closePrice2 {
			options["close[price2]"] = closePrice2
		}
		if let deadline = deadline {
			options["deadline"] = deadline
		}
		if let userref = userref {
			options["userref"] = "\(userref)"
		}
        request.postRequest(with: "AddOrder", params: options, completion: completion)
    }

	/// Place a new order.
	///
	/// Note: See the `AssetPairs` endpoint for details on the available trading pairs, their price and quantity precisions, order minimums, available leverage, etc.
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/addOrder)
	///
	/// - Parameters:
	///   - orderType: Order Type ["market", "limit", "stop-loss", "take-profit", "stop-loss-limit", "take-profit-limit", "settle-position"]
	///   - type: Order Direction ["buy", "sell"]
	///   - pair: Asset pair `id` or `altname`
	///   - volume: Order quantity in terms of the base asset (Note: Volume can be specified as `0` for closing margin orders to automatically fill the requisite quantity)
	///   - price: Price (**Limit price** for `limit` orders, **Trigger price** for `stop-loss`, `stop-loss-limit`, `take-profit` and `take-profit-limit` orders)
	///   - price2: Secondary Price (**Limit price** for `stop-loss-limit` and `take-profit-limit` orders) **Note**: Either price or price2 can be preceded by +, -, or # to specify the order price as an offset relative to the last traded price. + adds the amount to, and - subtracts the amount from the last traded price. # will either add or subtract the amount to the last traded price, depending on the direction and order type used. Relative prices can be suffixed with a % to signify the relative amount as a percentage.
	///   - trigger: Price signal used to trigger `stop-loss`, `stop-loss-limit`, `take-profit` and `take-profit-limit` orders. (Default: "last") ["index", "last"]
	///   - leverage: Amount of lerverage desired (Default: "none")
	///   - oflags: List of order flags (`post`: post-only order (order type = limit), `fcib`: prefer fee in base currency, `gciq`: prefer fee in quote currency, `nompp`: disable market price protection for market orders
	///   - timeinforce: Time-in-force of the order to specify how long it should remain in the order book before being cancelled. **GTC** (Good-'til-cancelled) is default if the parameter is omitted. **IOC** (immediate-or-cancel) will immediately execute the amount possible and cancel any remaining balance rather than resting in the book. **GTD** (good-'til-date), if specified, must coincide with a desired `expiretm`. (Default: "GTC") ["GTC", "IOC", "GTD"]
	///   - starttm: Scheduled start time. Can be specified as an absolute timestamp or as a number of seconds in the future. (`0`: now (default), `+<n>`: schedule start time  seconds from now, `<n>`: unix timestamp of start time
	///   - expiretm: Expiration time (`0`: no expiration (default), `+<n>`: expire  seconds from now, `<n>`: unix timestamp of expiration time
	///   - closeOrdertype: Conditional close order type. ["limit", "stop-loss", "take-profit", "stop-loss-limit", "take-profit-limit"]
	///   - closePrice: Conditional close order `price`
	///   - closePrice2: Conditional close order `price2`
	///   - deadline: RFC3339 timestamp (e.g. 2021-04-01T00:18:45Z) after which the matching engine should reject the new order request, in presence of latency or order queueing. min now() + 2 seconds, max now() + 60 seconds.
	///   - validate: Validate inputs only. Do not submit order.
	///   - userref: User reference id. `userref` is an optional user-specified integer id that can be associated with any number of orders. Many clients choose a `userref` corresponding to a unique integer id generated by their systems (e.g. a timestamp). However, because we don't enforce uniqueness on our side, it can also be used to easily group orders by pair, side, strategy, etc. This allows clients to more readily cancel or query information about orders in a particular group, with fewer API calls by using `userref` instead of our `txid`, where supported.
	///
	public func addOrder(orderType: OrderType,
						 direction: OrderDirection,
						 pair: String,
						 volume: String? = nil,
						 price: String? = nil,
						 price2: String? = nil,
						 trigger: OrderTrigger = .last,
						 leverage: String? = nil,
						 oflags: [OrderFlag]? = nil,
						 timeinforce: TimeInForceType = .GTC,
						 starttm: String = "0",
						 expiretm: String = "0",
						 closeOrdertype: CloseOrderType? = nil,
						 closePrice: String? = nil,
						 closePrice2: String? = nil,
						 deadline: String? = nil,
						 validate: Bool = false,
						 userref: Int? = nil) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["ordertype"] = orderType.rawValue
		options["type"] = direction.rawValue
		options["trigger"] = trigger.rawValue
		options["timeinforce"] = timeinforce.rawValue
		options["starttm"] = starttm
		options["expiretm"] = expiretm
		options["validate"] = "\(validate)"

		if let volume = volume {
			options["volume"] = volume
		}
		if let price = price {
			options["price"] = price
		}
		if let price2 = price2 {
			options["price2"] = price2
		}
		if let leverage = leverage {
			options["leverage"] = leverage
		}
		if let oflags = oflags {
			options["oflags"] = oflags.map { $0.rawValue }.joined(separator: ",")
		}
		if let closeOrdertype = closeOrdertype {
			options["close[ordertype]"] = closeOrdertype.rawValue
		}
		if let closePrice = closePrice {
			options["close[price]"] = closePrice
		}
		if let closePrice2 = closePrice2 {
			options["close[price2]"] = closePrice2
		}
		if let deadline = deadline {
			options["deadline"] = deadline
		}
		if let userref = userref {
			options["userref"] = "\(userref)"
		}
		return await request.postRequest(with: "AddOrder", params: options)
	}

	// MARK: Cancel Order

    /// Cancel a particular open order (or set of open orders) by `txid` or `userref`
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/cancelOrder)
	///
	/// - Parameter txid: Open order transaction ID (txid) or user reference (userref)
	///
	public func cancelOrder(txid: String, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		var options: [String: String] = [:]
        options["txid"] = txid
        request.postRequest(with: "CancelOrder", params: options, completion: completion)
    }

	/// Cancel a particular open order (or set of open orders) by `txid` or `userref`
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/cancelOrder)
	///
	/// - Parameter txid: Open order transaction ID (txid) or user reference (userref)
	///
	public func cancelOrder(txid: String) async -> KrakenNetwork.KrakenResult {
		var options: [String: String] = [:]
		options["txid"] = txid
		return await request.postRequest(with: "CancelOrder", params: options)
	}

	// MARK: Cancel All Orders

    /// Cancel all open orders
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/cancelAllOrders)
    public func cancelAllOrders(completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
		request.postRequest(with: "CancelAll", completion: completion)
    }

	/// Cancel all open orders
	///
	/// [See API Reference](https://docs.kraken.com/rest/#operation/cancelAllOrders)
	public func cancelAllOrders() async -> KrakenNetwork.KrakenResult {
		await request.postRequest(with: "CancelAll")
	}

	// MARK: Cancel All Orders After

	/// Cancel All Orders After X
	///
	/// CancelAllOrdersAfter provides a "Dead Man's Switch" mechanism to protect the client from network malfunction, extreme latency or unexpected matching engine downtime. The client can send a request with a timeout (in seconds), that will start a countdown timer which will cancel all client orders when the timer expires. The client has to keep sending new requests to push back the trigger time, or deactivate the mechanism by specifying a timeout of 0. If the timer expires, all orders are cancelled and then the timer remains disabled until the client provides a new (non-zero) timeout.
	///
	/// The recommended use is to make a call every 15 to 30 seconds, providing a timeout of 60 seconds. This allows the client to keep the orders in place in case of a brief disconnection or transient delay, while keeping them safe in case of a network breakdown. It is also recommended to disable the timer ahead of regularly scheduled trading engine maintenance (if the timer is enabled, all orders will be cancelled when the trading engine comes back from downtime - planned or otherwise).
	///
	///  [See API Reference](https://docs.kraken.com/rest/#operation/cancelAllOrdersAfter)
	///
	/// - Parameters:
	///   - timeout: Duration (in seconds) to set/extend the timer by
	///
    public func cancelAllAfter(timeout: Int, completion: @escaping (KrakenNetwork.KrakenResult) -> ()) {
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
	/// [See API Reference](https://docs.kraken.com/rest/#operation/cancelAllOrdersAfter)
	///
	/// - Parameters:
	///   - timeout: Duration (in seconds) to set/extend the timer by
	///
	public func cancelAllAfter(timeout: Int) async -> KrakenNetwork.KrakenResult {
		var optionsCopy: [String: String] = [:]
		optionsCopy["timeout"] = "\(timeout)"
		return await request.postRequest(with: "CancelAllOrdersAfter", params: optionsCopy)
	}
    
}
