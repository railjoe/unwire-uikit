//
//  SearchResultDataSource.swift
//  unwire
//
//  Created by Jovan Stojanov on 27.4.23..
//

import UIKit

class SearchResultDataSource: NSObject, UITableViewDataSource {
    
    var state : SearchViewModel.UiState?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(state) {
        case .initial:
            tableView.hideEmptyView()
            return 0
        case .loading:
            tableView.hideEmptyView()
            return 0
        case let .success(results):
            tableView.hideEmptyView()
            return results.count
        case let .empty(title, message):
            tableView.showEmptyView(title: title, message: message)
            return 0
        case let .failure(title, message):
            tableView.showEmptyView(title: title, message: message)
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
            cell.releaseDateLabel.text = result.releaseDate
            cell.artworkImageView.loadImage(result.artworkURL)
            cell.shortDescriptionLabel.text = result.shortDescription
        default:
            break
        }
        
        return cell
    }
}

