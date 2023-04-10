//
//  SearchCoordinator.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    private let repository: SearchMusicRespository!
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
        self.repository = SearchMusicRespositoryImpl()
    }
    
    func start() {
        let searchViewController = SearchViewController.loadFromNib()
        searchViewController.viewModel = SearchViewModel(searchMusic: SearchMusicImpl(repository: repository))
        navigationController.pushViewController(searchViewController, animated: false)
    }
    
    func didSelect(_ searchResult: SearchResult){
        
    }

}
