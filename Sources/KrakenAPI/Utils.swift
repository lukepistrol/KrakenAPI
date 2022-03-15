//
//  Utils.swift
//  KrakenAPI
//
//  Created by Lukas Pistrol on 13.03.2022.
//  Copyright © 2022 Lukas Pistrol. All rights reserved.
//

import Foundation

/// Error Type for Kraken REST API call
public enum KrakenError: Error {

	/// API Error
    case errorAPI(_ reason: String)

	/// Networking Error
    case errorNetworking(_ reason: String)

	/// Unknown/Other Error
	case unknown(_ error: Error?)
}

extension KrakenError {
	/// The description of the passed Error instance
	public var description: String {
		switch self {
		case .errorAPI(let reason):
			return reason
		case .errorNetworking(let reason):
			return reason
		case .unknown(let error):
			return error?.localizedDescription ?? "No Error Description"
		}
	}
}

extension Sequence where Iterator.Element: Equatable {
    func contains(array: [Iterator.Element]) -> Bool {
        for item in array {
            if !self.contains(item) {
                return false
            }
        }
        return true
    }
}

/// Append the conforming Types content to `Data`
public protocol DataConvertible {
    static func + (lhs: Data, rhs: Self) -> Data
    static func += (lhs: inout Data, rhs: Self)
}

extension DataConvertible {
    public static func + (lhs: Data, rhs: Self) -> Data {
        var value = rhs
        let data = Data(bytes: &value, count: 1)
        // let data = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
        return lhs + data
    }
    
    public static func += (lhs: inout Data, rhs: Self) {
        lhs += rhs
    }
}

extension UInt8 : DataConvertible { }
extension UInt16 : DataConvertible { }
extension UInt32 : DataConvertible { }

extension Int : DataConvertible { }
extension Float : DataConvertible { }
extension Double : DataConvertible { }

extension String : DataConvertible {
    public static func + (lhs: Data, rhs: String) -> Data {
        guard let data = rhs.data(using: .utf8) else { return lhs}
        return lhs + data
    }
}

extension Data : DataConvertible {
    public static func + (lhs: Data, rhs: Data) -> Data {
        var data = Data()
        data.append(lhs)
        data.append(rhs)
        
        return data
    }
}
