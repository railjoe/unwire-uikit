//
//  iTunesSearchAPIServiceTests.swift
//  unwireTests
//
//  Created by Jovan Stojanov on 28.4.23..
//

import XCTest
@testable import unwire

final class iTunesSearchAPIServiceTests: XCTestCase, Mockable {
    
    private var mockRestClient: RestClient!
    
    private var configuration: URLSessionConfiguration!
    
    private var service: iTunesSearchAPIService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        URLProtocol.registerClass(MockURLProtocol.self)
        
        configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        
        mockRestClient = RestClientImpl(sessionConfig: configuration)
        service = iTunesSearchAPIServiceImpl(mockRestClient)
    }
    
    override func tearDownWithError() throws {
        mockRestClient = nil
        service = nil
        
        try super.tearDownWithError()
    }
    
    func testNoResults() async throws {

        MockURLProtocol.mockData["/dk/search?term=&media=music&entity=musicTrack&country=dk&limit=50"] = loadData(filename: "empty_response")
        
        let expectedResult = SearchResultsResponseDto(resultCount: 0, results: [])
        
        let result = await service
            .search(term: "", media: .music, entity: .musicTrack, country: "dk", limit: 50)
        
        XCTAssertEqual(result, .success(expectedResult))
    }
    
    func testClientResultsSuccess() async throws {

        MockURLProtocol.mockData["/dk/search?term=mock&media=music&entity=musicTrack&country=dk&limit=1"] = loadData(filename: "mock_response")
        
        let searchResults: [SearchResultDto] = [SearchResultDto(trackID: 1481664301)]
        
        let expectedResult = SearchResultsResponseDto(resultCount: searchResults.count, results: searchResults)
        
        let result = await service
            .search(term: "mock", media: .music, entity: .musicTrack, country: "dk", limit: 1)
        
        XCTAssertEqual(result, .success(expectedResult))
    }

}
