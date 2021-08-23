//
//  MovieCell.swift
//  Movies
//
//  Created by Christian Quicano on 23/08/21.
//

import UIKit

class MovieCell: UITableViewCell {
    
    static let identifier = "MovieCell"

    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieOverviewLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!
    
    func configureCell(title: String?, overview: String?, imageData: Data?) {
        movieTitleLabel.text = title
        movieOverviewLabel.text = overview
        movieImageView.image = nil
        if let data = imageData {
            movieImageView.image = UIImage(data: data)
        }
    }
    
}
