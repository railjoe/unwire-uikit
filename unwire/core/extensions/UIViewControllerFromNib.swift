//
//  UIViewControllerFromNib.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            T(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
}
