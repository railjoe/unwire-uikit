//
//  MockiTunesSearchAPIService.swift
//  unwireTests
//
//  Created by Jovan Stojanov on 28.4.23..
//

import Foundation

@testable import unwire

class MockiTunesSearchAPIService: iTunesSearchAPIService {
    
    var result: Result<SearchResultsResponseDto, SearchAPIError>!
    
    func search(term: String, media: MediaType, entity: MediaTypeEntity, country: String, limit: Int) async -> Result<SearchResultsResponseDto, SearchAPIError> {
        return result
    }
}
