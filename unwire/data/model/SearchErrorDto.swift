//
//  SearchErrorDto.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation

struct SearchErrorDto: Codable {
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case errorMessage
    }
}
