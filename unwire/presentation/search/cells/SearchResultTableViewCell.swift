//
//  SearchResultTableViewCell.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var artworkImageView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        artworkImageView.layer.cornerRadius = 5.0
        artworkImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        artworkImageView.image = nil
        artworkImageView.cancelImageLoad()
    }
}
