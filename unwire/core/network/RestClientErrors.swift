//
//  RestClientErrors.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

enum RestClientErrors: Error {
    case requestFailed(error: Error)
    case responseFailed(code: Int, data: Data)
    case unknown
}

