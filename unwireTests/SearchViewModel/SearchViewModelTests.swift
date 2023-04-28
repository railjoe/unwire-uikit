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

        mockSearchMusic.result = Result<[SearchResult], SearchAPIError>.success(searchResults)
        viewModelToTest.onChange("test")

        wait(for: [expectation], timeout: 1)
    }

    func testSearchViewModelFailure() {

        let expectation = XCTestExpectation(description: "State is set to .failure")

        let error = SearchAPIError.unknownError

        viewModelToTest.$state.dropFirst(2).sink { state in
            XCTAssertEqual(state, .failure(title: NSLocalizedString("search_music.error_title", comment: ""), messsage: NSLocalizedString("search_music.error_message", comment: "")))
            expectation.fulfill()
        }.store(in: &cancellables)

        mockSearchMusic.result = Result<[SearchResult], SearchAPIError>.failure(error)
        viewModelToTest.onChange("test")

        wait(for: [expectation], timeout: 1)
    }

    func testSearchViewModelSuccess() {

        let expectation = XCTestExpectation(description: "State is set to .success")

        let searchResults: [SearchResult] = [SearchResult(id: 0, trackName: "", artistName: "", shortDescription: "", artworkURL: nil, releaseDate: nil)]

        viewModelToTest.$state.dropFirst(2).sink { state in
            XCTAssertEqual(state, .success(searchResults))
            expectation.fulfill()
        }.store(in: &cancellables)

        mockSearchMusic.result = Result<[SearchResult], SearchAPIError>.success(searchResults)
        viewModelToTest.onChange("test")

        wait(for: [expectation], timeout: 1)
    }
    
    func testSearchViewModelEmpty() {

        let expectation = XCTestExpectation(description: "State is set to .empty")

        viewModelToTest.$state.dropFirst(2).sink { state in
            XCTAssertEqual(state, .empty(title: NSLocalizedString("search_music.no_results_title", comment: ""), messsage: NSLocalizedString("search_music.no_results_message", comment: "")))
            expectation.fulfill()
        }.store(in: &cancellables)

        mockSearchMusic.result = Result<[SearchResult], SearchAPIError>.success([])
        viewModelToTest.onChange("test")

        wait(for: [expectation], timeout: 1)
    }
}



