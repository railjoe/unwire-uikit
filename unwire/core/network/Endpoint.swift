//
//  Endpoint.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

protocol Endpoint {
    var url: URL { get }
    var path: String { get }
}
