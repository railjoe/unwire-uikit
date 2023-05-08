//
//  SearchResult.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

struct SearchResult: Identifiable, Equatable {
    let id: Int
    let trackName: String?
    let artistName: String?
    let shortDescription: String?
    let artworkURL: URL?
    let releaseDate: String?
    
    init(id: Int, trackName: String?, artistName: String?, shortDescription: String?, artworkURL: URL?, releaseDate: String?) {
        self.id = id
        self.trackName = trackName
        self.artistName = artistName
        self.shortDescription = shortDescription
        self.artworkURL = artworkURL
        self.releaseDate = releaseDate
    }
    
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        return lhs.id == rhs.id
    }
    
    #if DEBUG
    init(id: Int) {
        self.id = id
        self.trackName = nil
        self.artistName = nil
        self.shortDescription = nil
        self.artworkURL = nil
        self.releaseDate = nil
    }
    #endif
}
