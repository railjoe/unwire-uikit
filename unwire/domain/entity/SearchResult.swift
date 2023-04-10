//
//  SearchResult.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

struct SearchResult: Identifiable {
    let id: Int?
    let trackName: String?
    let artistName: String?
    let shortDescription: String?
    let artworkURL: URL?
    let releaseDate: Date?
    
    init(id: Int?, trackName: String?, artistName: String?, shortDescription: String?, artworkURL: URL?, releaseDate: Date?) {
        self.id = id
        self.trackName = trackName
        self.artistName = artistName
        self.shortDescription = shortDescription
        self.artworkURL = artworkURL
        self.releaseDate = releaseDate
    }
}
