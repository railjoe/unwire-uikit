//
//  RestClient.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

protocol RestClient {
    func get<E: Endpoint>(_ endpoint: E) async -> Result<Data, RestClientErrors>
}
