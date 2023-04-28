//
//  SearchAPIError.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

enum SearchAPIError: Error, Equatable {
    
    case requestError(error: Error)
    case responseError(message: String)
    case jsonDecode(error: Error)
    case unknownError
    
    static func == (lhs: SearchAPIError, rhs: SearchAPIError) -> Bool {
        switch (lhs, rhs) {
        case (.requestError, .requestError): return true
        case (.responseError, .responseError): return true
        case (.jsonDecode, .jsonDecode): return true
        case (.unknownError, .unknownError): return true
        default: return false
        }
    }
}
