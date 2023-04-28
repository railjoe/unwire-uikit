//
//  MockSearchMusic.swift
//  unwireTests
//
//  Created by Jovan Stojanov on 28.4.23..
//

import Foundation
@testable import unwire

class MockSearchMusic: SearchMusic {
    var result: Result<[SearchResult], SearchAPIError>!
    
    func invoke(term: String, country: String, limit: Int) async -> Result<[SearchResult], SearchAPIError> {
        return result
    }
}
