//
//  SearchMusicRespositoryTEsts.swift
//  unwireTests
//
//  Created by Jovan Stojanov on 28.4.23..
//

import XCTest

@testable import unwire

final class SearchMusicRespositoryTests: XCTestCase {
    
    private var mockService: MockiTunesSearchAPIService!
    
    private var respository: SearchMusicRespository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        mockService = MockiTunesSearchAPIService()
        respository = SearchMusicRespositoryImpl(mockService)
    }
    
    override func tearDownWithError() throws {
        mockService = nil
        respository = nil
        
        try super.tearDownWithError()
    }
    
    func testAPIServiceSuccess() async throws {

        let searchResults: [SearchResultDto] = [SearchResultDto(trackID: 0)]
        
        let mockResult = SearchResultsResponseDto(resultCount: searchResults.count, results: searchResults)
        
        let adaptor = SearchResultAdaptor()
        
        let expectedResult = mockResult.results?.map({ dto in
            adaptor.toSearchResult(dto)
        }) ?? []
        
        mockService.result = Result<SearchResultsResponseDto, SearchAPIError>.success(mockResult)
        
        let result = await respository.search(term: "Lukas Graham", country: "dk", limit: 50)
        
        XCTAssertEqual(result, .success(expectedResult))
    }
    
    func testAPIServiceNoResults() async throws {

        let searchResults: [SearchResultDto] = []
        
        let mockResult = SearchResultsResponseDto(resultCount: searchResults.count, results: searchResults)
        
        let expectedResult: [SearchResult] = []
        
        mockService.result = Result<SearchResultsResponseDto, SearchAPIError>.success(mockResult)
        
        let result = await respository.search(term: "Lukas Graham", country: "dk", limit: 50)
        
        XCTAssertEqual(result, .success(expectedResult))
    }
    
    func testAPIServiceError() async throws {

        let error = SearchAPIError.unknownError
        
        mockService.result = Result<SearchResultsResponseDto, SearchAPIError>.failure(error)
        
        let result = await respository.search(term: "Lukas Graham", country: "dk", limit: 50)
        
        XCTAssertEqual(result, .failure(error))
    }
}
