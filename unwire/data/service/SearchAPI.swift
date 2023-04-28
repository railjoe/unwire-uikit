//
//  SearchAPI.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

enum MediaType: String {
    case movie, podcast, music, musicVideo, audiobook, shortFilm, tvShow, software, ebook, all
}

enum MediaTypeEntity: String {
    case musicArtist, musicTrack, album, musicVideo, mix, song
}

enum SearchAPI: Endpoint {
    
    private enum Constants {
        static let scheme = "https"
        static let host = "itunes.apple.com"
        static let searchPath = "search"
    }
    
    var url: URL? {
        switch self {
        case .search(let term, let media, let entity, let country, let limit):
            var components = URLComponents()
            components.host = Constants.host
            components.scheme = Constants.scheme
            components.path = "/\(country)/search"
            components.queryItems = [
                URLQueryItem(name: "term", value: term),
                URLQueryItem(name: "media", value: media.rawValue),
                URLQueryItem(name: "entity", value: entity.rawValue),
                URLQueryItem(name: "country", value: country),
                URLQueryItem(name: "limit", value: String(limit)),
            ]
            return components.url
        }
    }
    
    case search(term: String, media: MediaType, entity: MediaTypeEntity, country: String, limit: Int)
}
