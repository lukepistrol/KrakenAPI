//
//  Kraken.swift
//  KrakenAPI
//
//  Created by Lukas Pistrol on 13.03.2022.
//  Copyright © 2022 Lukas Pistrol. All rights reserved.
//

import Foundation

/***
    Kraken REST API

    [See Reference here](https://docs.kraken.com/rest/)

    Requests:
    Request payloads are form-encoded (```Content-Type: application/x-www-form-urlencoded```), and all requests must specify a ```User-Agent``` in their headers.

    Responses:
    Responses are JSON encoded and contain one or two top-level keys (```result``` and ```error``` for successful requests or those with warnings, or only error for failed or rejected requests)

    Error Details:
    HTTP status codes are generally not used by our API to convey information about the state of requests -- any errors or warnings are denoted in the error field of the response as described above. Status codes other than 200 indicate that there was an issue with the request reaching our servers.

    ```error``` messages follow the general format ```<severity><category>:<error msg>```[```:add'l text```]

    - ```severity``` can be either ```E``` for error or ```W``` for warning
    - ```category``` can be one of ```General```, ```Auth```, ```API```, ```Query```, ```Order```, ```Trade```, ```Funding```, or ```Service```
    - ```error msg``` can be any text string that describes the reason for the error
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
    
    // MARK: Public methods
    
    public init(credentials: Credentials) {
        request = KrakenNetwork(credentials: credentials)
    }
    
    /// Get the server's time.
    public func serverTime(completion: @escaping KrakenNetwork.AsyncOperation) {
        request.getRequest(with: "Time", completion: completion)
    }

    // TODO: Test This
    /// Get the current system status or trading mode.
    public func systemStatus(completion: @escaping KrakenNetwork.AsyncOperation) {
        request.getRequest(with: "SystemStatus", completion: completion)
    }

    
    /// Get information about the assets that are available for deposit, withdrawal, trading and staking.
    public func assets(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.getRequest(with: "Assets", params: options, completion: completion)
    }
    
    /// Get tradable asset pairs
    public func assetPairs(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.getRequest(with: "AssetPairs", params: options, completion: completion)
    }
    
    /// Get Ticker Information.
    /// 
    /// Note: Today's prices start at midnight UTC
    public func ticker(pairs: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Ticker", params: optionsCopy, completion: completion)
    }

    // TODO: Test This
    /// Get OHLC Data
    /// 
    /// Note: the last entry in the OHLC array is for the current, not-yet-committed frame and will always be present, regardless of the value of ```since```.
    public func ohlcData(pair: String, options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pair
        request.getRequest(with: "OHLC", params: optionsCopy, completion: completion)
    }
    
    /// Get Order Book
    public func orderBook(pairs: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Depth", params: optionsCopy, completion: completion)
    }
    
    /// Returns the last 1000 trades by default
    public func trades(pairs: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Trades", params: optionsCopy, completion: completion)
    }
    
    /// Get Recent Spreads
    public func spread(pairs: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Spread", params: optionsCopy, completion: completion)
    }
    
    // MARK: Private methods
    
    /// Retrieve all cash balances, net of pending withdrawals.
    public func accountBalance(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "Balance", params: options, completion: completion)
    }
    
    /// Retrieve a summary of collateral balances, margin position valuations, equity and margin level.
    public func tradeBalance(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "TradeBalance", params: options, completion: completion)
    }
    
    /// Retrieve information about currently open orders.
    public func openOrders(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "OpenOrders", params: options, completion: completion)
    }

    // TODO: Test This
    /// Retrieve information about orders that have been closed (filled or cancelled). 50 results are returned at a time, the most recent by default.
    /// 
    /// Note: If an order's tx ID is given for ```start``` or ```end``` time, the order's opening time (```opentm```) is used
    public func closedOrders(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "ClosedOrders", params: options, completion: completion)
    }
    
    /// Retrieve information about specific orders.
    public func queryOrders(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "QueryOrders", params: options, completion: completion)
    }
    
    /// Retrieve information about trades/fills. 50 results are returned at a time, the most recent by default.
    ///
    /// Unless otherwise stated, costs, fees, prices, and volumes are specified with the precision for the asset pair (```pair_decimals``` and ```lot_decimals```), not the individual assets' precision (```decimals```).
    public func tradesHistory(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "TradesHistory", params: options, completion: completion)
    }
    
    /// Retrieve information about specific trades/fills.
    public func queryTrades(ids: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["txid"] = ids.joined(separator: ",")
        request.postRequest(with: "QueryTrades", params: optionsCopy, completion: completion)
    }
    
    /// Get information about open margin positions.
    public func openPositions(ids: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["txid"] = ids.joined(separator: ",")
        request.postRequest(with: "OpenPositions", params: optionsCopy, completion: completion)
    }
    
    /// Retrieve information about ledger entries. 50 results are returned at a time, the most recent by default.
    public func ledgersInfo(options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        request.postRequest(with: "Ledgers", params: options, completion: completion)
    }
    
    /// Retrieve information about specific ledger entries.
    public func queryLedgers(ledgerIds: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["id"] = ledgerIds.joined(separator: ",")
        request.postRequest(with: "QueryLedgers", params: optionsCopy, completion: completion)
    }
    
    /// Get Trade Volume
    ///
    /// Note: If an asset pair is on a maker/taker fee schedule, the taker side is given in ```fees``` and maker side in ```fees_maker```. For pairs not on maker/taker, they will only be given in ```fees```.
    public func tradeVolume(pairs: [String], options: [String: String]? = nil, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.postRequest(with: "TradeVolume", params: optionsCopy, completion: completion)
    }

    /// Place a new order.
    ///
    /// Note: See the `AssetPairs` endpoint for details on the available trading pairs, their price and quantity precisions, order minimums, available leverage, etc.
    public func addOrder(options: [String: String], completion: @escaping KrakenNetwork.AsyncOperation) {
        let valuesNeeded = ["pair", "type", "orderType", "volume"]
        guard options.keys.contains(array: valuesNeeded) else {
            fatalError("Required options, not given. Input must include \(valuesNeeded)")
        }
        request.postRequest(with: "AddOrder", params: options, completion: completion)
    }
    
    /// Cancel a particular open order (or set of open orders) by ```txid``` or ```userref```
    public func cancelOrder(ids: [String], completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy: [String: String] = [:]
        optionsCopy["txid"] = ids.joined(separator: ",")
        request.postRequest(with: "CancelOrder", params: optionsCopy, completion: completion)
    }

    // TODO: Test This
    /// Cancel all open orders
    public func cancelAllOrders(completion: @escaping KrakenNetwork.AsyncOperation) {
		request.postRequest(with: "CancelAll", completion: completion)
    }

    /// Cancel All Orders After X
    /// 
    /// CancelAllOrdersAfter provides a "Dead Man's Switch" mechanism to protect the client from network malfunction, extreme latency or unexpected matching engine downtime. The client can send a request with a timeout (in seconds), that will start a countdown timer which will cancel all client orders when the timer expires. The client has to keep sending new requests to push back the trigger time, or deactivate the mechanism by specifying a timeout of 0. If the timer expires, all orders are cancelled and then the timer remains disabled until the client provides a new (non-zero) timeout.
    ///
    ///The recommended use is to make a call every 15 to 30 seconds, providing a timeout of 60 seconds. This allows the client to keep the orders in place in case of a brief disconnection or transient delay, while keeping them safe in case of a network breakdown. It is also recommended to disable the timer ahead of regularly scheduled trading engine maintenance (if the timer is enabled, all orders will be cancelled when the trading engine comes back from downtime - planned or otherwise).   
    public func cancelAllAfter(timeout: Int, completion: @escaping KrakenNetwork.AsyncOperation) {
        var optionsCopy: [String: String] = [:]
        optionsCopy["timeout"] = "\(timeout)"
        request.postRequest(with: "CancelAllOrdersAfter", params: optionsCopy, completion: completion)
    }
    
}
