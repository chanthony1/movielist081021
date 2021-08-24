//
//  ViewController.swift
//  Movies
//
//  Created by Christian Quicano on 23/08/21.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpBinding()
    }
    
    private func setUpBinding() {
        
        // create binding of movies
        viewModel.moviesBinding = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.fetchMovies()
    }
    
}

extension MoviesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell
        else { return UITableViewCell() }
        
        let row = indexPath.row
        let title = viewModel.getTitle(at: row)
        let overview = viewModel.getOverview(at: row)
        cell.configureCell(title: title, overview: overview, imageData: nil)
        
        return cell
    }
    
}

extension MoviesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98.0
    }
    
}
