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
    
    private let queue = DispatchQueue(label: "image-loader-queue",attributes: [.concurrent])
    
    private init() {}
    
    func load(_ url: URL?, for imageView: UIImageView) {
        
        let token = imageLoader.loadImage(url) { result in
            defer {
                self.queue.async(flags:.barrier) { [weak self] in
                    self?.uuidMap.removeValue(forKey: imageView)
                }
            }
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch {
            }
        }
        if let token = token {
            queue.async(flags:.barrier) { [weak self] in
                self?.uuidMap[imageView] = token
            }
        }
    }
    
    func cancel(for imageView: UIImageView) {
        queue.async { [weak self] in
            if let uuid = self?.uuidMap[imageView] {
                self?.imageLoader.cancelLoad(uuid)
                self?.queue.async(flags:.barrier) { [weak self] in
                    self?.uuidMap.removeValue(forKey: imageView)
                }
            }
        }
    }
}

