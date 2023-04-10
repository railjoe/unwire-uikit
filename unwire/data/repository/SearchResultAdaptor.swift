//
//  SearchResultAdaptor.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

struct SearchResultAdaptor {
    static func toSearchResult(_ searchResultDto: SearchResultDto) -> SearchResult {
        return SearchResult(id: searchResultDto.trackID, trackName: searchResultDto.trackName, artistName: searchResultDto.artistName, shortDescription: searchResultDto.collectionName, artworkURL: searchResultDto.artworkUrl100, releaseDate: searchResultDto.releaseDate)
    }
}
