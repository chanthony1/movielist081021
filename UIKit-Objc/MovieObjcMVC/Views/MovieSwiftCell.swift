//
//  MovieSwiftCell.swift
//  MovieObjcMVC
//
//  Created by Christian Quicano on 13/09/21.
//

import UIKit

@objc class MovieSwiftCell: UITableViewCell {
    
    @objc static let identifier = "MovieCell"
    
    //  MARK:- private properties
    lazy private var mainStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy private var movieImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy private var labelsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy private var movieTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy private var movieOverviewLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK:- internal funcs
    @objc func configureCell(title: String?, overview: String?, imageData: Data?) {
        
        setUpUI()
        
        movieTitleLabel.text = title
        movieOverviewLabel.text = overview
        movieImageView.image = nil
        if let data = imageData {
            movieImageView.image = UIImage(data: data)
        }
    }
    
    // MARK:- private funcs
    private func setUpUI() {
        
        labelsStackView.addArrangedSubview(movieTitleLabel)
        labelsStackView.addArrangedSubview(movieOverviewLabel)
        
        mainStackView.addArrangedSubview(movieImageView)
        mainStackView.addArrangedSubview(labelsStackView)
        
        contentView.addSubview(mainStackView)
        
        // contraints
        movieImageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        movieTitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        movieImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        let safeArea = contentView.safeAreaLayoutGuide
        mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8.0).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8.0).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8.0).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8.0).isActive = true
    }

}
