//
//  SearchAPIError.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

enum SearchAPIError: Error {
    case requestError(error: Error)
    case responseError(message: String)
    case jsonDecode(error: Error)
    case unknownError
}
