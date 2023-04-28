//
//  SearchMusicRespository.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

protocol SearchMusicRespository {
    func search(term: String, country: String, limit: Int) async -> Result<[SearchResult], SearchAPIError>
}
