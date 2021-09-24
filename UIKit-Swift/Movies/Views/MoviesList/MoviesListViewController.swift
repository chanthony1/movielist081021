//
//  ViewController.swift
//  Movies
//
//  Created by Christian Quicano on 23/08/21.
//

// UserDefault

import UIKit
import Combine
import MovieModule

class MoviesListViewController: UIViewController {
    
    // MARK: - internal properties
    weak var coordinator: Coordinator?
    var viewModel: MovieViewModel?
    
    // MARK: - private properties
    private var subscribers = Set<AnyCancellable>()
    
    // MARK: - private properties ui
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
        searchBar.searchTextField.accessibilityIdentifier = Accessibility.MoviesList.searchBar
        return searchBar
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.accessibilityIdentifier = Accessibility.MoviesList.tableView
        return tableView
    }()
    
    // MARK:- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies list"
        
        MovieListConfigurator.configure(view: self)
        
        setUpUI()
        setUpBinding()
        
    }
    
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
        viewModel?
            .moviesBinding
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscribers)
        
        viewModel?
            .errorBinding
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.showErrorAlert(message: message)
            }
            .store(in: &subscribers)
        
        viewModel?.getMovies()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default)
        alert.addAction(acceptAction)
        present(alert, animated: true)
    }
    
}

// MARK: - UISearchBarDelegate
extension MoviesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterMovies(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension MoviesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell
        else { return UITableViewCell() }
        
        let row = indexPath.row
        let title = viewModel?.getTitle(at: row)
        let overview = viewModel?.getOverview(at: row)
        let data = viewModel?.getImageData(at: row)
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
        
        guard let identifier = viewModel?.getMovieId(at: indexPath.row)
        else { return }
        
        coordinator?.showMovieDetails(with: identifier)
    }
    
}
