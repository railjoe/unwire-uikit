//
//  Coordinator.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import UIKit

protocol Coordinator {
    var parent: Coordinator? { get set }
    
    var navigationController: UINavigationController { get set }
    
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    
}
