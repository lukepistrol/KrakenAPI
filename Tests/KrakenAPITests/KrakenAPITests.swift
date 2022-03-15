import XCTest
@testable import KrakenAPI

final class KrakenAPITests: XCTestCase {

	var kraken: Kraken = Kraken(
		credentials: Kraken.Credentials(apiKey: ENV.API_KEY, privateKey: ENV.PRIVATE_KEY)
	)

	func testServerTime() async throws {
		let result = await kraken.serverTime()

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
    }

	func testSystemStatus() async throws {
		let result = await kraken.systemStatus()

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testAssets() async throws {
		let result = await kraken.assets()

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testAssetPairs() async throws {
		let result = await kraken.assetPairs()

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testTicker() async throws {
		let result = await kraken.ticker(pair: "XBTUSD")

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testOHLC() async throws {
		let result = await kraken.ohlcData(pair: "XBTEUR")

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testOrderBook() async throws {
		let result = await kraken.orderBook(pair: "XBTEUR")

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testTrades() async throws {
		let result = await kraken.trades(pair: "XBTEUR")

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testSpread() async throws {
		let result = await kraken.spread(pair: "XBTEUR")

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testBalance() async throws {
		let result = await kraken.accountBalance()

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testTradeBalance() async throws {
		let result = await kraken.tradeBalance()

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testOpenOrders() async throws {
		let result = await kraken.openOrders()

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testClosedOrders() async throws {
		let result = await kraken.closedOrders()

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testQueryOrders() async throws {
		let result = await kraken.queryOrders(txids: [""])

		switch result {
		case .success(let result): XCTAssert(false, result.description)
		case .failure(let error): XCTAssert(true, error.localizedDescription)
		}
	}

	func testTradesHistory() async throws {
		let result = await kraken.tradesHistory()

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testQueryTrades() async throws {
		let result = await kraken.queryTrades()

		switch result {
		case .success(let result): XCTAssert(false, result.description)
		case .failure(let error): XCTAssert(true, (error as NSError).debugDescription)
		}
	}

	func testOpenPositions() async throws {
		let result = await kraken.openPositions()

		switch result {
		case .success(let result): XCTAssert(false, result.description)
		case .failure(let error): XCTAssert(true, error.localizedDescription)
		}
	}

	func testLedgersInfo() async throws {
		let result = await kraken.ledgersInfo()

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testQueryLedgers() async throws {
		let result = await kraken.queryLedgers()

		switch result {
		case .success(let result): XCTAssert(false, result.description)
		case .failure(let error): XCTAssert(true, error.description)
		}
	}

	func testTradeVolume() async throws {
		let result = await kraken.tradeVolume(pairs: ["XBTEUR"])

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testCancelAllOrders() async throws {
		let result = await kraken.cancelAllOrders()

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}

	func testCancelAllOrdersAfter() async throws {
		let result = await kraken.cancelAllAfter(timeout: 1)

		switch result {
		case .success(let result): XCTAssert(true, result.description)
		case .failure(let error): XCTFail((error as NSError).debugDescription)
		}
	}
}
