//
//  RestClientImpl.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation
import Combine

class RestClientImpl: RestClient {
    private let session: URLSession
    
    init(sessionConfig: URLSessionConfiguration? = nil) {
        self.session = URLSession(configuration: sessionConfig ?? URLSessionConfiguration.default)
    }
    
    func get<E>(_ endpoint: E) -> AnyPublisher<Data, Error> where E: Endpoint {
        startRequest(for: endpoint, method: "GET", jsonBody: nil as String?)
            .eraseToAnyPublisher()
    }
    
    private func startRequest<T: Encodable, S: Endpoint>(for endpoint: S,
                                                         method: String,
                                                         jsonBody: T? = nil)
    -> AnyPublisher<Data, Error> {
        var request: URLRequest
        
        do {
            request = try buildRequest(endpoint: endpoint, method: method, jsonBody: jsonBody)
        } catch {
            return Fail(error: RestClientErrors.requestFailed(error: error)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .mapError { (error: Error) -> Error in
                return RestClientErrors.requestFailed(error: error)
            }
            .tryMap { (data: Data, response: URLResponse) in
                let response = response as! HTTPURLResponse
                if response.statusCode > 299 {
                    throw RestClientErrors.responseFailed(code: response.statusCode, data: data)
                }
                return data
            }.eraseToAnyPublisher()
    }
    
    private func buildRequest<T: Encodable, S: Endpoint>(endpoint: S,
                                                         method: String,
                                                         jsonBody: T?) throws -> URLRequest {
        var request = URLRequest(url: endpoint.url, timeoutInterval: 30)
        request.httpMethod = method
        if let body = jsonBody {
            request.httpBody = try JSONEncoder().encode(body)
        }
        return request
    }
}
