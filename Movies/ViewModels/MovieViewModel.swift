//
//  MovieViewModel.swift
//  Movies
//
//  Created by Christian Quicano on 24/08/21.
//

import Foundation

class MovieViewModel {
    
    // communication = closure, delegate/protocol, observer
    
    // MARK:- internal properties
    var moviesBinding: (() -> Void)?
    var count: Int { movies.count }
    func getTitle(at row: Int) -> String { movies[row].originalTitle }
    func getOverview(at row: Int) -> String { movies[row].overview }
    
    // MARK:- private properties
    private var movies = [Movie]()
    private let networkManager = NetworkManager()
    
    // MARK:- internal properties
    func fetchMovies() {
        // create the url
        let urlS = "https://api.themoviedb.org/3/movie/popular?api_key=6622998c4ceac172a976a1136b204df4&language=en-US"
        
        networkManager.getMovies(from: urlS) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.moviesBinding?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
