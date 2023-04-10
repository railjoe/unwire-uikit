//
//  SearchMusicRespositoryImpl.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Combine

class SearchMusicRespositoryImpl: SearchMusicRespository {
    private let service: iTunesSearchAPIService
    
    init(_ service: iTunesSearchAPIService = iTunesSearchAPIServiceImpl()) {
        self.service = service
    }
    
    func search(term: String, country: String, limit: Int) -> AnyPublisher<[SearchResult], SearchAPIError> {
        return service.search(term: term, media: MediaType.music, entity: MediaTypeEntity.musicTrack, country: country, limit: limit)
            .map({ response in
                response.results?.map({ dto in
                    SearchResultAdaptor.toSearchResult(dto)
                }) ?? []
            }).eraseToAnyPublisher()
    }
}
