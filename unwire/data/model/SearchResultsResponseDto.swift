//
//  SearchResultsResponseDto.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

struct SearchResultsResponseDto: Codable, Equatable {
    
    let resultCount: Int?
    let results: [SearchResultDto]?
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
    
    static func == (lhs: SearchResultsResponseDto, rhs: SearchResultsResponseDto) -> Bool {
        return lhs.resultCount == rhs.resultCount && lhs.results == rhs.results
    }
}
