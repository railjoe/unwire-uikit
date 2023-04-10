//
//  unwireTests.swift
//  unwireTests
//
//  Created by Jovan Stojanov on 10.4.23..
//

import XCTest
import Combine

@testable import unwire

final class SearchMusicTests: XCTestCase {
    private var searchMusic: SearchMusic!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        searchMusic = SearchMusicImpl()
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        searchMusic = nil
        cancellables = nil
        
        try super.tearDownWithError()
    }
    
    func testAPIServiceSuccess() throws {
        let expectation = XCTestExpectation(description: "API returned one or more results")
        
        searchMusic
            .invoke(term: "Lukas Graham", country: "dk", limit: 50)
            .sink { error in
                
            } receiveValue: { result in
                switch(result){
                case let .success(results):
                    XCTAssertFalse(results.isEmpty)
                case let .failure(error):
                    XCTAssertNil(error)
                }
                expectation.fulfill()
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testAPIServiceNoResults() throws {
        let expectation = XCTestExpectation(description: "API returned no results")
        
        searchMusic
            .invoke(term: "", country: "dk", limit: 50)
            .sink { error in
                
            } receiveValue: { result in
                switch(result){
                case let .success(results):
                    XCTAssertTrue(results.isEmpty)
                case let .failure(error):
                    XCTAssertNil(error)
                }
                expectation.fulfill()
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testAPIServiceError() throws {
        let expectation = XCTestExpectation(description: "API returned error")
        
        searchMusic
            .invoke(term: "", country: "", limit: -1)
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            } receiveValue: { result in
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
}
