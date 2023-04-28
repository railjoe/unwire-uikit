//
//  SearchMusicRespositoryImpl.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

class SearchMusicRespositoryImpl: SearchMusicRespository {
    private let service: iTunesSearchAPIService
    
    init(_ service: iTunesSearchAPIService = iTunesSearchAPIServiceImpl()) {
        self.service = service
    }
    
    func search(term: String, country: String, limit: Int) async -> Result<[SearchResult], SearchAPIError> {
        let adaptor = SearchResultAdaptor()
        return await service.search(term: term, media: MediaType.music, entity: MediaTypeEntity.musicTrack, country: country, limit: limit)
            .map({ response in
                response.results?.map({ dto in
                    adaptor.toSearchResult(dto)
                }) ?? []
            })
    }
}
