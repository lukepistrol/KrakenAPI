//
//  KrakenNetwork.swift
//  KrakenAPI
//
//  Created by Lukas Pistrol on 13.03.2022.
//  Copyright © 2022 Lukas Pistrol. All rights reserved.
//

import Foundation
import CryptoSwift

public struct KrakenNetwork {

	/// The type of the request [public | private]
    public enum RequestType: String {
		/// points to http://api.kraken.com/0/public/
        case publicRequest = "public"

		/// points to http://api.kraken.com/0/private/
        case privateRequest = "private"
    }

	/// Result Type: KrakenResult<[String: Any]>
    public typealias AsyncOperation = (KrakenResult<[String: Any]>) -> Void

	/// Result Type: KrakenResult<[String: Any]>
	public typealias AsyncResult = KrakenResult<[String: Any]>

	/// Kraken Credentials for API calls
    private let credentials: Kraken.Credentials

	/// API Version
    private let version = "0"

	/// Kraken Base URL
    private let krakenUrl = "api.kraken.com"

	/// HTTPS URL Scheme
    private let scheme = "https"

    init(credentials: Kraken.Credentials) {
        self.credentials = credentials
    }


	/// Creates an URL from given parameters for Kraken REST API
	/// - Parameters:
	///   - method: The desired Kraken API endpoint
	///   - params: The parameters for the API endpoint
	///   - type: The type of the endpoint [public | private]
	/// - Returns: An URL
    private func createURL(with method: String, params: [String:String], type: RequestType) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = krakenUrl
        urlComponents.path =  "/" + version + "/" + type.rawValue + "/" + method
        
        if type == RequestType.publicRequest {
            urlComponents.query = encode(params: params)
        }
        
        return urlComponents.url
    }

	/// Encodes a Dictionary of parameters to a URL-friendly String
	/// - Parameter params: The parameters for the API endpoint
	/// - Returns: A String containing all parameters
    private func encode(params: [String : String]) -> String {
        var urlComponents = URLComponents()
        var parameters: [URLQueryItem] = []
        let parametersDictionary = params
        
        for (key, value) in parametersDictionary {
            let newParameter = URLQueryItem(name: key, value: value)
            parameters.append(newParameter)
        }
        
        urlComponents.queryItems = parameters
        return urlComponents.url?.query ?? ""
    }

	/// Initiates a GET Request on the Kraken REST API
	/// - Parameters:
	///   - method: The desired Kraken API endpoint
	///   - params: The parameters for the API endpoint
	///   - type: The type of the endpoint [public | private]
	///   - completion: completion handler callback
	internal func getRequest(with method: String, params: [String : String]? = [:], type: RequestType = .publicRequest,
                    completion: @escaping AsyncOperation) {
        let params = params ?? [:]
        guard let url = createURL(with: method, params:params, type: type) else {
            fatalError()
        }
        
        let request = URLRequest(url: url)
        
        rawRequest(request, completion: completion)
	}

	/// Initiates a GET Request on the Kraken REST API
	/// - Parameters:
	///   - method: The desired Kraken API endpoint
	///   - params: The parameters for the API endpoint
	///   - type: The type of the endpoint [public | private]
	/// - Returns: KrakenResult<[String: Any]>
	internal func getRequest(with method: String, params: [String : String]? = [:], type: RequestType = .publicRequest) async -> AsyncResult {
		return await withCheckedContinuation { continuation in
			getRequest(with: method, params: params, type: type) { result in
				continuation.resume(returning: result)
			}
		}
	}
	

	/// Initiates a POST Request on the Kraken REST API
	/// - Parameters:
	///   - path: The desired Kraken API endpoint
	///   - params: The parameters for the API endpoint
	///   - type: The type of the endpoint [public | private]
	///   - completion: completion handler callback
	internal func postRequest(with path: String, params: [String : String]? = nil, type: RequestType = .privateRequest,
                     completion: @escaping AsyncOperation) {
        
        let params = addNonce(to:params)
        let urlParams = encode(params: params)
        
        guard let url = createURL(with: path, params: params, type: type),
            let signature = try? generateSignature(url, params:params) else {
                fatalError()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = urlParams.data(using: .utf8)
        request.setValue(credentials.apiKey, forHTTPHeaderField: "API-Key")
        request.setValue(signature, forHTTPHeaderField: "API-Sign")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        for (key, value) in params {
            request.setValue(value, forHTTPHeaderField: key)
        }
        rawRequest(request, completion: completion)
	}

	/// Initiates a POST Request on the Kraken REST API
	/// - Parameters:
	///   - path: The desired Kraken API endpoint
	///   - params: The parameters for the API endpoint
	///   - type: The type of the endpoint [public | private]
	/// - Returns: KrakenResult<[String: Any]>
	internal func postRequest(with path: String, params: [String : String]? = nil, type: RequestType = .privateRequest) async -> AsyncResult {
		return await withCheckedContinuation { continuation in
			postRequest(with: path, params: params, type: type) { result in
				continuation.resume(returning: result)
			}
		}
	}


	/// Calls the Kraken API
	/// - Parameters:
	///   - request: The URLRequest
	///   - completion: completion handler callback
	private func rawRequest(_ request: URLRequest, completion: @escaping AsyncOperation) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, let _ = response else {
                return completion(.failure(error!))
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String : AnyObject] else {
                    return completion(.failure(KrakenError.errorNetworking(reason: "Wrong JSON structure")))
                }
                if let errorArray = json["error"] as? [String] {
                    if !errorArray.isEmpty {
                        return completion(.failure(KrakenError.errorAPI(reason: errorArray.first!)))
                    }
                }
                guard let result = json["result"] as? [String: Any] else {
					return completion(.failure(KrakenError.errorAPI(reason: "No Result found")))
				}
                return completion(.success(result))
                
            } catch let error as NSError {
                return completion(.failure(KrakenError.errorNetworking(reason: "Error JSON parsing: \(error.localizedDescription)")))
            }
            
            }
        task.resume()
	}

	/// Calls the Kraken API
	/// - Parameters:
	///   - request: The URLRequest
	/// - Returns: KrakenResult<[String: Any]>
	private func rawRequest(_ request: URLRequest) async -> AsyncResult {
		return await withCheckedContinuation { continuation in
			rawRequest(request) { result in
				continuation.resume(returning: result)
			}
		}
	}


	/// Generates a signature for the Kraken REST API call
	/// - Parameters:
	///   - url: The URL
	///   - params: The Parameters
	/// - Returns: A String
    private func generateSignature(_ url: URL, params: [String:String]) throws  -> String {
        let path = url.path
        let encodedParams = encode(params: params)
        guard let decodedSecret = Data(base64Encoded: credentials.privateKey),
            let nonce = params["nonce"],
            let digest = (nonce + encodedParams).data(using: .utf8),
            let encodedPath = path.data(using: .utf8) else {
                throw KrakenError.errorAPI(reason: "Error encoding signature")
        }
        
        let message = digest.sha256()
        let messagePath = encodedPath + message
        
        let signature = try HMAC(key: decodedSecret.bytes, variant: .sha2(.sha512)).authenticate(messagePath.bytes)
        
        return Data(signature).base64EncodedString()
    }

	/// Takes the parameters and adds a ```nonce``` parameter to the Dictionary
	/// - Parameter params: The parameters
	/// - Returns: A Dictionary of parameters
    private func addNonce(to params: [String : String]?) -> [String: String] {
        var paramsWithNonce = params ?? [:]
        let nonce = String(Int(Date().timeIntervalSinceReferenceDate*1000))
        paramsWithNonce["nonce"] = nonce
        return paramsWithNonce
        
    }
}
