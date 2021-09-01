//
//  MoviesRepositoryRemote.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation
import Combine

class MoviesRepositoryRemote: BaseRepositoryRemote<MoviesResponse> {
    
    func getMovies() -> AnyPublisher<[Movie], NetworkError> {
        getData()
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    
}
