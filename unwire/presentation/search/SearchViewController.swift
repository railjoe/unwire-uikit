//
//  SearchViewController.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    var tableView = UITableView(frame: CGRectZero, style: .plain)
    
    var activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    private var cancelables = [AnyCancellable]()
    
    private var dataSource = SearchResultDataSource()
    
    var viewModel: SearchViewModel
    
    var coordinator: SearchCoordinator?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    required init(viewModel: SearchViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(tableView)
          
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(nib: SearchResultTableViewCell.self)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        activityIndicatorView.startAnimating()
        
        searchController.searchResultsUpdater = self
        
        tableView.tableHeaderView = searchController.searchBar
        
        navigationItem.title = viewModel.titleText
        
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholderText
        
        viewModel.$state.sink { [weak self] state in
            switch(state){
            case .initial:
                self?.activityIndicatorView.stopAnimating()
            case .loading:
                self?.activityIndicatorView.startAnimating()
            case .failure(_, _):
                self?.activityIndicatorView.stopAnimating()
            case .empty(_, _):
                self?.activityIndicatorView.stopAnimating()
            case .success(_):
                self?.activityIndicatorView.stopAnimating()
            }
            self?.dataSource.state = state
            self?.tableView.reloadData()
        }.store(in: &cancelables)
        
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.onChange(searchController.searchBar.text ?? "")
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch(dataSource.state){
        case let .success(results):
            let result = results[indexPath.row]
            coordinator?.didSelect(result)
        default:
            break
        }
    }
}

