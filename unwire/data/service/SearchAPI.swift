//
//  SearchAPI.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

private let baseURL = URL(string: "https://itunes.apple.com/")

enum MediaType: String {
    case movie, podcast, music, musicVideo, audiobook, shortFilm, tvShow, software, ebook, all
}

enum MediaTypeEntity: String {
    case musicArtist, musicTrack, album, musicVideo, mix, song
}

enum SearchAPI: Endpoint {
    var url: URL {
        return URL(string: self.path, relativeTo: baseURL)!
    }
    
    var path: String {
        switch self {
        case .search(let term, let media, let entity, let country, let limit):
            return "\(country)/search?term=\(term.urlEncoded ?? "")&media=\(media)&entity=\(entity)&country=\(country)&limit=\(limit)"
        }
    }
    
    case search(term: String, media: MediaType, entity: MediaTypeEntity, country: String, limit: Int)
}
