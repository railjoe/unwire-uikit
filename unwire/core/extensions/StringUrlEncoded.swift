//
//  StringUrlEncoded.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

private let urlAllowed: CharacterSet =
    .alphanumerics.union(.init(charactersIn: "-._~")) // as per RFC 3986

extension String {
    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: urlAllowed)
    }
}

