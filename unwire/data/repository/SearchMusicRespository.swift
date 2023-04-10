//
//  SearchMusicRespository.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Combine

protocol SearchMusicRespository {
    func search(term: String, country: String, limit: Int) -> AnyPublisher<[SearchResult], SearchAPIError>
}
