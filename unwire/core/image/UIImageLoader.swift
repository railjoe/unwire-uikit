//
//  UIImageLoader.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation
import UIKit

class UIImageLoader {
    
    static let shared = UIImageLoader()
    
    private let imageLoader = ImageLoader()
    
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
    
    func load(_ url: URL?, for imageView: UIImageView) {
        
        let token = imageLoader.loadImage(url) { result in
            defer { self.uuidMap.removeValue(forKey: imageView) }
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch {
            }
        }
        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}

