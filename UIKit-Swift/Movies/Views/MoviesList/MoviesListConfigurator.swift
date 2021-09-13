//
//  MoviesListConfigurator.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation

class MovieListConfigurator {
    
    static func configure(view: MoviesListViewController) {
        
        // Assembling of ViewModel
        let moviesRemote = MoviesRepositoryRemote(url: NetworkUrl.moviesPopular)
        let movieLocal = MovieRepositoryLocal()
        let repository = MovieRepository(moviesRemote: moviesRemote, movieLocal: movieLocal)
        
        let viewModel = MovieViewModel(repository: repository)
        view.viewModel = viewModel
    }
    
}
