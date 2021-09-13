//
//  MoviesRepositoryRemote.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation
import Combine

class MoviesRepositoryRemote: BaseRepositoryRemote {
    
    typealias T = MoviesResponse
    
    var url: String
    var networkManager: NetworkManager
    var decoder: JSONDecoder
    var subscribers: Set<AnyCancellable>
    
    required init(url: String = "",
                  networkManager: NetworkManager = MainNetworkManager.shared,
                  decoder: JSONDecoder = JSONDecoder(),
                  subscribers: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.url = url
        self.networkManager = networkManager
        self.decoder = decoder
        self.subscribers = subscribers
    }
    
    func getMovies() -> AnyPublisher<[Movie], NetworkError> {
        getData()
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    
}
