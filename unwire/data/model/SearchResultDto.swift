//
//  SearchResultDto.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

struct SearchResultDto: Codable, Equatable {
    let wrapperType, kind: String?
    let trackID: Int
    let artistID, collectionID : Int?
    let artistName, collectionName, trackName, collectionCensoredName: String?
    let trackCensoredName: String?
    let collectionArtistID: Int?
    let collectionArtistName: String?
    let artistViewURL, collectionViewURL, trackViewURL: URL?
    let previewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: URL?
    let collectionPrice, trackPrice: Double?
    let releaseDate: Date?
    let collectionExplicitness, trackExplicitness: String?
    let discCount, discNumber, trackCount, trackNumber: Int?
    let trackTimeMillis: Int?
    let country, currency, primaryGenreName: String?
    let isStreamable: Bool?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case collectionArtistID = "collectionArtistId"
        case collectionArtistName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, isStreamable
    }
    
    static func == (lhs: SearchResultDto, rhs: SearchResultDto) -> Bool {
        return lhs.trackID == rhs.trackID
    }
    
    #if DEBUG
    
    init(trackID: Int) {
        self.trackID = trackID
        wrapperType = nil
        kind = nil
        artistID = nil
        collectionID = nil
        artistName = nil
        collectionName = nil
        trackName = nil
        collectionCensoredName = nil
        trackCensoredName = nil
        collectionArtistID = nil
        collectionArtistName = nil
        artistViewURL = nil
        collectionViewURL = nil
        trackViewURL = nil
        previewURL = nil
        artworkUrl30 = nil
        artworkUrl60 = nil
        artworkUrl100 = nil
        collectionPrice = nil
        trackPrice = nil
        releaseDate = nil
        collectionExplicitness = nil
        trackExplicitness = nil
        discCount = nil
        discNumber = nil
        trackCount = nil
        trackNumber = nil
        trackTimeMillis = nil
        country = nil
        currency = nil
        primaryGenreName = nil
        isStreamable = nil
    }
    
    #endif
}
