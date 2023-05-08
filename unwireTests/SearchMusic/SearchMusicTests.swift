//
//  unwireTests.swift
//  unwireTests
//
//  Created by Jovan Stojanov on 10.4.23..
//

import XCTest

@testable import unwire

final class SearchMusicTests: XCTestCase {
    
    private var mockSearchMusicRespository: MockSearchMusicRespository!
    
    private var searchMusic: SearchMusic!
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        mockSearchMusicRespository = MockSearchMusicRespository()
        searchMusic = SearchMusicImpl(repository: mockSearchMusicRespository)
    }
    
    override func tearDownWithError() throws {
        mockSearchMusicRespository = nil
        searchMusic = nil
        
        try super.tearDownWithError()
    }
    
    func testSuccess() async throws {

        let searchResults: [SearchResult] = [SearchResult(id: 0, trackName: "", artistName: "", shortDescription: "", artworkURL: nil, releaseDate: nil)]
        
        mockSearchMusicRespository.result = Result<[SearchResult], SearchAPIError>.success(searchResults)
        let result = await searchMusic
            .invoke(term: "Lukas Graham", country: "dk", limit: 50)
        
        XCTAssertEqual(result, .success(searchResults))
    }
    
    func testNoResults() async throws {

        let searchResults: [SearchResult] = []
        
        mockSearchMusicRespository.result = Result<[SearchResult], SearchAPIError>.success(searchResults)
        let result = await searchMusic
            .invoke(term: "Lukas Graham", country: "dk", limit: 50)
        
        XCTAssertEqual(result, .success(searchResults))
    }
    
    func testError() async throws {

        let error = SearchAPIError.unknownError
        
        mockSearchMusicRespository.result = Result<[SearchResult], SearchAPIError>.failure(error)
        let result = await searchMusic
            .invoke(term: "Lukas Graham", country: "dk", limit: 50)
        
        XCTAssertEqual(result, .failure(error))
    }
}
