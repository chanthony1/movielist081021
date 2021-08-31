//
//  ViewController.swift
//  Movies
//
//  Created by Christian Quicano on 23/08/21.
//

// UserDefault

import UIKit
import Combine

class MoviesListViewController: UIViewController {
    
    weak var coordinator: Coordinator?
    
//    @IBOutlet private weak var tableView: UITableView!
    
    lazy private var mainStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy private var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private var viewModel: MovieViewModelType = MovieViewModel()
    private var subscribers = Set<AnyCancellable>()
//    private var indexPathSelected: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies list"
        
        setUpUI()
        setUpBinding()
        
        // USerDefaults
//        let userDefaults = UserDefaults.standard
//        let key = "currentYear"
//        let currentYear = userDefaults.object(forKey: key)
//        print(currentYear)
//        UserDefaults.standard.set(2021, forKey: key)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let indexPathSelected = indexPathSelected
//        else { return }
//
//        if segue.identifier == "showDetails" {
//            if let destination = segue.destination as? MovieDetailsViewController {
//                let identifier = viewModel.getMovieId(at: indexPathSelected.row)
//                destination.movieId = identifier
//            }
//        }
//
//    }
    
    // MARK:- private funcs
    private func setUpUI() {
        view.backgroundColor = .white
        
        mainStackView.addArrangedSubview(searchBar)
        mainStackView.addArrangedSubview(tableView)
        
        view.addSubview(mainStackView)
        
        // create constraint
        let safeArea = view.safeAreaLayoutGuide
        mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    private func setUpBinding() {
        
        // create binding of movies
        viewModel
            .moviesBinding
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscribers)
        
        // create binding for errors
        viewModel
            .errorBinding
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] messageError in
                self?.displayErrorAlert(messageError)
            }
            .store(in: &subscribers)
        
        // binding to update row
        viewModel
            .updateRowBinding
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] row in
                self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            }
            .store(in: &subscribers)
        
        viewModel.fetchMovies()
    }
    
    private func displayErrorAlert(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default)
        alert.addAction(acceptAction)
        present(alert, animated: true)
    }
    
}

// MARK: - UISearchBarDelegate
extension MoviesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - UITableViewDataSource
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
        let data = viewModel.getImage(at: row)
        cell.configureCell(title: title, overview: overview, imageData: data)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension MoviesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let identifier = viewModel.getMovieId(at: indexPath.row)
        coordinator?.showMovieDetails(with: identifier)
        
//        indexPathSelected = indexPath
//        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
}
