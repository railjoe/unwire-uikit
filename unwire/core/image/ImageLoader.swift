//
//  ImageLoader.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation
import UIKit

class ImageLoader {
    
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func loadImage(_ url: URL?, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        guard let url = url else {
            return nil
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            completion(.success(imageFromCache))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            defer { self?.runningRequests.removeValue(forKey: uuid) }
            
            if let data = data, let image = UIImage(data: data) {
                self?.imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
                completion(.success(image))
                return
            }
            
            guard let error = error else {
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        task.resume()
        
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}

