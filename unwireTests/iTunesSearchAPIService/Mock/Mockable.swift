//
//  Mockable.swift
//  unwireTests
//
//  Created by Jovan Stojanov on 28.4.23..
//

import Foundation

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadData(filename: String) -> Data
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadData(filename: String) -> Data {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }
        do {
            let data = try Data(contentsOf: path)
            return data
        } catch {
            fatalError("Failed to decode loaded JSON")
        }
    }
    
}
