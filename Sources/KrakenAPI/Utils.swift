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
    case errorAPI(reason: String)
    case errorNetworking(reason: String)
}

public enum KrakenResult<Value> {
    case success(Value)
    case failure(Error)
    
    public func dematerialize() throws -> Value {
        switch self {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }
    
    public func map<U>(_ transform: (Value) -> U) -> KrakenResult<U> {
        return flatMap { .success(transform($0)) }
    }
    
    public func flatMap<U>(_ transform: (Value) -> KrakenResult<U>) -> KrakenResult<U> {
        return analysis(
            ifSuccess: transform,
            ifFailure: KrakenResult<U>.failure)
    }
    
    public func analysis<Result>(ifSuccess: (Value) -> Result, ifFailure: (Error) -> Result) -> Result {
        switch self {
        case let .success(value):
            return ifSuccess(value)
        case let .failure(value):
            return ifFailure(value)
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
