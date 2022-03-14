//
//  Kraken+Types.swift
//  KrakenAPI
//
//  Created by Lukas Pistrol on 14.03.2022.
//  Copyright © 2022 Lukas Pistrol. All rights reserved.
//

import Foundation

public extension Kraken {

	/// Info to retreive when getting tradable asset pairs
	///
	/// Default: ``AssetPairInfo/info``
	enum AssetPairInfo: String {
		case info = "info"
		case leverage = "leverage"
		case fees = "fees"
		case margin = "margin"
	}

	/// Time frame interval in minutes for getting OHLC data
	///
	/// Default: ``OHLCInterval/i1min``
	enum OHLCInterval: String {
		case i1min = "1"
		case i5min = "5"
		case i15min = "15"
		case i30min = "30"
		case i60min = "60"
		case i240min = "240"
		case i1440min = "1440"
		case i10080min = "10080"
		case i21600min = "21600"
	}

	/// Which time to use to search when getting closed orders
	///
	/// Default: ``ClosedOrdersTime/both``
	enum ClosedOrdersTime: String {
		case both = "both"
		case open = "open"
		case close = "close"
	}

	/// Type of trade when getting trades history
	///
	/// Default: ``TradesHistoryType/all``
	enum TradesHistoryType: String {
		case all = "all"
		case anyPosition = "any position"
		case closedPosition = "closed position"
		case closingPosition = "closing position"
		case noPosition = "no position"
	}

	/// Consolidate positions by market/pair when getting open positions.
	///
	/// Default: ``OpenPositionConsolidation/market``
	enum OpenPositionConsolidation: String {
		case market = "market"
		case pair = "pair"
	}

	/// Type of ledger to retrieve
	///
	/// Default: ``LedgerType/all``
	enum LedgerType: String {
		case all = "all"
		case deposit = "deposit"
		case withdrawal = "withdrawal"
		case trade = "trade"
		case margin = "margin"
		case rollover = "rollover"
		case credit = "credit"
		case transfer = "transfer"
		case settled = "settled"
		case staking = "staking"
		case sale = "sale"
	}

	/// Order Type
	enum OrderType: String {
		case market = "market"
		case limit = "limit"
		case stopLoss = "stop-loss"
		case takeProfit = "take-profit"
		case stopLossLimit = "stop-loss-limit"
		case takeProfitLimit = "take-profit-limit"
		case settlePosition = "settle-position"
	}

	/// Order Direction (buy/sell)
	enum OrderDirection: String {
		case buy = "buy"
		case sell = "sell"
	}

	/// Price signal used to trigger `stop-loss`, `stop-loss-limit`, `take-profit` and `take-profit-limit` orders.
	enum OrderTrigger: String {
		case index = "index"
		case last = "last"
	}

	/// List of order flags
	///
	/// * ``post``: post-only order (order type = limit)
	/// * ``fcib``: prefer fee in base currency
	/// * ``gciq``: prefer fee in quote currency
	/// * ``nompp``: disable market price protection for market orders
	enum OrderFlag: String {
		/// post-only order (order type = limit)
		case post = "post"

		/// prefer fee in base currency. Mutually exclusive with ``gciq``
		case fcib = "fcib"

		/// prefer fee in quote currency. Mutually exclusive with ``fcib``
		case gciq = "gciq"

		/// disable market price protection for market orders
		case nompp = "nompp"
	}

	/// Time-in-force of the order to specify how long it should remain in the order book before being cancelled.
	///
	/// * ``GTC`` (Good-'til-cancelled) is default if the parameter is omitted.
	/// * ``IOC`` (immediate-or-cancel) will immediately execute the amount possible and cancel any remaining balance rather than resting in the book.
	/// * ``GTD`` (good-'til-date), if specified, must coincide with a desired `expiretm`.
	enum TimeInForceType: String {
		/// (Good-'til-cancelled) is default if the parameter is omitted.
		case GTC = "GTC"

		/// (immediate-or-cancel) will immediately execute the amount possible and cancel any remaining balance rather than resting in the book.
		case IOC = "IOC"

		/// (good-'til-date), if specified, must coincide with a desired `expiretm`.
		case GTD = "GTD"
	}

	/// Conditional close order type.
	enum CloseOrderType: String {
		case limit = "limit"
		case stopLoss = "stop-loss"
		case takeProfit = "take-profit"
		case stopLossLimit = "stop-loss-limit"
		case takeProfitLimit = "take-profit-limit"
	}
}
