//
//  SearchMusic.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Combine

protocol SearchMusic {
    func invoke(term: String, country: String, limit: Int) -> AnyPublisher<Result<[SearchResult], SearchAPIError>, Never>
}

