//
//  RestClientImpl.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

class RestClientImpl: RestClient {
    private let session: URLSession
    
    init(sessionConfig: URLSessionConfiguration? = nil) {
        self.session = URLSession(configuration: sessionConfig ?? URLSessionConfiguration.default)
    }
    
    func get<E>(_ endpoint: E) async -> Result<Data, RestClientErrors> where E: Endpoint {
        await startRequest(for: endpoint, method: "GET", jsonBody: nil as String?)
    }
    
    private func startRequest<T: Encodable, S: Endpoint>(for endpoint: S,
                                                         method: String,
                                                         jsonBody: T? = nil) async
    -> Result<Data, RestClientErrors> {
        var request: URLRequest
        
        do {
            request = try buildRequest(endpoint: endpoint, method: method, jsonBody: jsonBody)
        } catch {
            return .failure(RestClientErrors.requestFailed(error: error))
        }
        do {
            let (data, response) = try await session.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(RestClientErrors.unknown)
            }
            switch response.statusCode {
            case 200...299:
                return .success(data)
            default:
                return .failure(RestClientErrors.responseFailed(code: response.statusCode, data: data))
            }
        } catch {
            return .failure(.unknown)
        }
    }
    
    private func buildRequest<T: Encodable, S: Endpoint>(endpoint: S,
                                                         method: String,
                                                         jsonBody: T?) throws -> URLRequest {
        guard let url = endpoint.url else {
            throw RestClientErrors.unknown
        }
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.httpMethod = method
        if let body = jsonBody {
            request.httpBody = try JSONEncoder().encode(body)
        }
        return request
    }
}
