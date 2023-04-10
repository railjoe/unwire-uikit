//
//  RestClient.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation
import Combine

protocol RestClient {
    func get<E: Endpoint>(_ endpoint: E) -> AnyPublisher<Data, Error>
}
