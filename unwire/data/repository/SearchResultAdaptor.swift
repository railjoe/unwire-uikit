//
//  SearchResultAdaptor.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

struct SearchResultAdaptor {
    private let dateFormat = DateFormatter()
    init() {
        dateFormat.dateStyle = .short
        dateFormat.timeZone = .none
    }
    func toSearchResult(_ searchResultDto: SearchResultDto) -> SearchResult {
        var date: String?
        if let releaseDate = searchResultDto.releaseDate {
            date = dateFormat.string(from: releaseDate)
        }
        
        return SearchResult(id: searchResultDto.trackID, trackName: searchResultDto.trackName, artistName: searchResultDto.artistName, shortDescription: searchResultDto.collectionName, artworkURL: searchResultDto.artworkUrl100, releaseDate: date)
    }
}
