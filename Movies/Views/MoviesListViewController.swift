//
//  ViewController.swift
//  Movies
//
//  Created by Christian Quicano on 23/08/21.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: MovieViewModelType = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        setUpBinding()
    }
    
    private func setUpBinding() {
        
        // create binding of movies
        viewModel.delegate = self
        
        viewModel.fetchMovies()
    }
    
}

extension MoviesListViewController: MovieViewModelDelegate {
    func displayMovies() {
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    func displayError(_ message: String) {
        DispatchQueue.main.async { [unowned self] in
            self.displayError(message)
        }
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
