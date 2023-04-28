//
//  iTuneSearchAPIServiceImpl.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

class iTunesSearchAPIServiceImpl: iTunesSearchAPIService {
    private let restClient: RestClient
    private let decoder = JSONDecoder()
    
    init(_ restClient: RestClient = RestClientImpl()) {
        self.restClient = restClient
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        self.decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func search(term: String, media: MediaType, entity: MediaTypeEntity, country: String, limit: Int) async -> Result<SearchResultsResponseDto, SearchAPIError> {
        
        do {
            let result = await restClient.get(SearchAPI.search(term: term, media: media, entity: entity, country: country, limit: limit))
            switch(result) {
            case .success(let data):
                return .success(try self.decoder.decode(SearchResultsResponseDto.self, from: data))
            case .failure(let error):
                switch(error) {
                case let .requestFailed(error):
                    return .failure(SearchAPIError.requestError(error: error))
                case let .responseFailed(code, data):
                    if code >= 400 {
                        do {
                            let searchError = try self.decoder.decode(SearchErrorDto.self, from: data)
                            if let errorMessage = searchError.errorMessage {
                                return .failure(SearchAPIError.responseError(message: errorMessage))
                            }
                        } catch {
                            return .failure(SearchAPIError.jsonDecode(error: error))
                        }
                    }
                    return .failure(SearchAPIError.unknownError)
                case .unknown:
                    return .failure(.unknownError)
                }
            }
        } catch {
            return .failure(SearchAPIError.jsonDecode(error: error))
        }
    }
}
