//
//  SearchViewModelTests.swift
//  unwireTests
//
//  Created by Jovan Stojanov on 10.4.23..
//

import XCTest
import Combine

@testable import unwire

final class SearchViewModelTests: XCTestCase {
    private var mockSearchMusic: MockSearchMusic!
    
    private var viewModelToTest: SearchViewModel!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockSearchMusic = MockSearchMusic()
        viewModelToTest = SearchViewModel(searchMusic: mockSearchMusic)
        cancellables = []
    }

    override func tearDownWithError() throws {
        mockSearchMusic = nil
        viewModelToTest = nil
        cancellables = nil
        
        try super.tearDownWithError()
    }
    
    func testSearchViewModelInitial() {

        let expectation = XCTestExpectation(description: "State is set to .initial")
        
        viewModelToTest.$state.sink { state in
            XCTAssertEqual(state, .initial)
            expectation.fulfill()
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
    
    func testSearchViewModelLoading() {

        let expectation = XCTestExpectation(description: "State is set to .loading")
        
        let searchResults: [SearchResult] = [SearchResult(id: 0, trackName: "", artistName: "", shortDescription: "", artworkURL: nil, releaseDate: nil)]
        
        viewModelToTest.$state.dropFirst().sink { state in
            XCTAssertEqual(state, .loading)
            expectation.fulfill()
        }.store(in: &cancellables)

        mockSearchMusic.result = Result<Result<[SearchResult], SearchAPIError>, Never>.success(.success(searchResults)).publisher.eraseToAnyPublisher()
        viewModelToTest.searchText = "test"

        wait(for: [expectation], timeout: 1)
    }
    
    func testSearchViewModelFailure() {

        let expectation = XCTestExpectation(description: "State is set to .failure")
        
        let error = SearchAPIError.unknownError
        
        viewModelToTest.$state.dropFirst(2).sink { state in
            XCTAssertEqual(state, .failure(error: error))
            expectation.fulfill()
        }.store(in: &cancellables)

        mockSearchMusic.result = Result<Result<[SearchResult], SearchAPIError>, Never>.success(.failure(error)).publisher.eraseToAnyPublisher()
        viewModelToTest.searchText = "test"

        wait(for: [expectation], timeout: 1)
    }
    
    func testSearchViewModelSuccess() {

        let expectation = XCTestExpectation(description: "State is set to .success")
        
        let searchResults: [SearchResult] = [SearchResult(id: 0, trackName: "", artistName: "", shortDescription: "", artworkURL: nil, releaseDate: nil)]
        
        viewModelToTest.$state.dropFirst(2).sink { state in
            XCTAssertEqual(state, .success(searchResults))
            expectation.fulfill()
        }.store(in: &cancellables)

        mockSearchMusic.result = Result<Result<[SearchResult], SearchAPIError>, Never>.success(.success(searchResults)).publisher.eraseToAnyPublisher()
        viewModelToTest.searchText = "test"

        wait(for: [expectation], timeout: 1)
    }
}

class MockSearchMusic: SearchMusic {
    var result: AnyPublisher<Result<[SearchResult], SearchAPIError>, Never>!
    
    func invoke(term: String, country: String, limit: Int) -> AnyPublisher<Result<[SearchResult], SearchAPIError>, Never> {
        return result
    }
}

