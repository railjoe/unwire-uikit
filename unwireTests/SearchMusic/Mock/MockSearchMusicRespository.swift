//
//  MockSearchMusicRespository.swift
//  unwireTests
//
//  Created by Jovan Stojanov on 28.4.23..
//

import Foundation
@testable import unwire

class MockSearchMusicRespository: SearchMusicRespository {
    var result: Result<[SearchResult], SearchAPIError>!
    
    func search(term: String, country: String, limit: Int) async -> Result<[SearchResult], SearchAPIError>{
        return result
    }
}
