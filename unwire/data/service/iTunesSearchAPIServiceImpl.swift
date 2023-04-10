//
//  iTuneSearchAPIServiceImpl.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation
import Combine

class iTunesSearchAPIServiceImpl: iTunesSearchAPIService {
    private let restClient: RestClient
    private let decoder = JSONDecoder()
    
    init(_ restClient: RestClient = RestClientImpl()) {
        self.restClient = restClient
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        self.decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func search(term: String, media: MediaType, entity: MediaTypeEntity, country: String, limit: Int) -> AnyPublisher<SearchResultsResponseDto, SearchAPIError> {
        restClient.get(SearchAPI.search(term: term, media: media, entity: entity, country: country, limit: limit))
            .mapError { (error) in
                if let restError = error as? RestClientErrors {
                    switch restError {
                    case let .requestFailed(error):
                        return SearchAPIError.requestError(error: error)
                    case let .responseFailed(code, data):
                        if code >= 400 {
                            do {
                                let searchError = try self.decoder.decode(SearchErrorDto.self, from: data)
                                if let errorMessage = searchError.errorMessage {
                                    return SearchAPIError.responseError(message: errorMessage)
                                }
                            } catch {
                                return SearchAPIError.jsonDecode(error: error)
                            }
                        }
                        return SearchAPIError.unknownError
                    }
                } else {
                    return SearchAPIError.unknownError
                }
            }
            .tryMap{
                do {
                    return try self.decoder.decode(SearchResultsResponseDto.self, from: $0)
                } catch {
                    throw SearchAPIError.jsonDecode(error: error)
                }
            }
            .mapError { (error) in
                return error as! SearchAPIError
            }
            .eraseToAnyPublisher()
    }
}
