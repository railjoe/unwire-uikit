//
//  SearchViewController.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var cancelables = [AnyCancellable]()
    
    private var dataSource = SearchResultDataSource()
    
    var viewModel: SearchViewModel!
    
    var coordinator: SearchCoordinator?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(viewModel != nil, "ViewModel must initalized before usage")
        
        tableView.register(nib: SearchResultTableViewCell.self)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        searchController.searchResultsUpdater = self
        
        tableView.tableHeaderView = searchController.searchBar
        
        navigationItem.title = NSLocalizedString("search_music.title", comment: "Search Music screen title")
        
        searchController.searchBar.placeholder = NSLocalizedString("search_music.placeholder", comment: "Search bar placeholder")
        
        viewModel.$state.sink { [weak self] state in
            switch(state){
            case .initial:
                self?.activityIndicatorView.stopAnimating()
            case .loading:
                self?.activityIndicatorView.startAnimating()
            case .failure(_):
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
        viewModel.searchText = searchController.searchBar.text ?? ""
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

class SearchResultDataSource: NSObject, UITableViewDataSource {
    
    private let dateFormat = DateFormatter()
    
    var state : SearchViewModel.UiState?
    
    override init() {
        dateFormat.dateStyle = .short
        dateFormat.timeZone = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(state) {
        case .initial:
            tableView.hideEmptyView()
            return 0
        case .loading:
            return 0
        case let .success(results):
            if results.isEmpty {
                tableView.showEmptyView(title: NSLocalizedString("search_music.no_results_title", comment: ""), message: NSLocalizedString("search_music.no_results_message", comment: ""))
            } else {
                tableView.hideEmptyView()
            }
            return results.count
        case .failure(_):
            tableView.showEmptyView(title: NSLocalizedString("search_music.error_title", comment: ""), message: NSLocalizedString("search_music.error_message", comment: ""))
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        switch(state){
        case let .success(results):
            let result = results[indexPath.row]
            cell.trackNameLabel.text = result.trackName
            cell.artistNameLabel.text = result.artistName
            if let releaseDate = result.releaseDate {
                cell.releaseDateLabel.text = dateFormat.string(from: releaseDate)
            } else {
                cell.releaseDateLabel.text = nil
            }
            cell.artworkImageView.loadImage(result.artworkURL)
            cell.shortDescriptionLabel.text = result.shortDescription
        default:
            break
        }
        
        return cell
    }
}

