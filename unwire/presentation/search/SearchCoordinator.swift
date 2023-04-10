//
//  SearchCoordinator.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController.loadFromNib()
        navigationController.pushViewController(searchViewController, animated: false)
    }
    
    func didSelect(_ searchResult: SearchResult){
        
    }

}
