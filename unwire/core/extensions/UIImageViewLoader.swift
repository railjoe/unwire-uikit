//
//  UIImageViewLoader.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import UIKit

extension UIImageView {
  func loadImage(_ url: URL?) {
    UIImageLoader.shared.load(url, for: self)
  }

  func cancelImageLoad() {
    UIImageLoader.shared.cancel(for: self)
  }
}

