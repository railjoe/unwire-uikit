//
//  iTuneSearchAPIService.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation
import Combine

protocol iTunesSearchAPIService {
    func search(term: String, media: MediaType, entity: MediaTypeEntity, country: String, limit: Int) async -> Result<SearchResultsResponseDto, SearchAPIError>
}
