//
//  MoviesListViewModel.swift
//  MovieModule
//
//  Created by Christian Quicano on 14/09/21.
//

import Foundation
import Combine

public class MoviesListViewModel: MoviesListViewModelType {
    
    @Published public var movies: [Movie] = []
    
    public var networkManager: NetworkManager
    public var urlMovies: String
    public var subscribers = Set<AnyCancellable>()
    
    public init(urlMovies: String = NetworkUrl.moviesPopular,
                networkManager: NetworkManager = MainNetworkManager.shared) {
        self.urlMovies = urlMovies
        self.networkManager = networkManager
    }
    
    public func getMovies() {
        networkManager
            .get(from: urlMovies)
            .decode(type: MoviesResponse.self, decoder: JSONDecoder())
            .sink { _ in }
                receiveValue: { [weak self] moviesResponse in
                    guard let self = self else { return }
                    self.movies = moviesResponse.results
            }
            .store(in: &subscribers)
    }
    
}
