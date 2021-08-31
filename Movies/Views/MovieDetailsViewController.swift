//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Christian Quicano on 30/08/21.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: - internal properties
    weak var coordinator: Coordinator?
    
    // MARK: - private properties
    private let movieId: Int
    
    // MARK: - init
    init(movieId: Int, coordinator: Coordinator? = nil) {
        self.movieId = movieId
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movieId)
        
        title = "Movie Detail of :\(movieId)"
        view.backgroundColor = .white
    }
    
}
