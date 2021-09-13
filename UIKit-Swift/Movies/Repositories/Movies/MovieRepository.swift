//
//  MovieRepository.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation
import Combine

class MovieRepository {
    
    var movieLocal: MovieRepositoryLocal?
    var moviesRemote: MoviesRepositoryRemote?
    var movieRemote: MovieRepositoryRemote?
    
    private var subscribers = Set<AnyCancellable>()

    init(moviesRemote: MoviesRepositoryRemote? = nil,
         movieRemote: MovieRepositoryRemote? = nil,
         movieLocal: MovieRepositoryLocal? = nil) {
        self.moviesRemote = moviesRemote
        self.movieRemote = movieRemote
        self.movieLocal = movieLocal
    }
    
    func getDetailMovie() -> AnyPublisher<Movie, NetworkError>? {
        movieRemote?.getData()
    }
    
    func searchMovieBy(_ identifier: Int) -> CDMovie? {
        let movie = movieLocal?.getMovie(identifier)
        return movie
    }
    
    func updateImageMovie(_ data: Data, by identifier: Int) {
        movieLocal?.updateImageMovie(data, by: identifier)
    }
    
    func downloadImage(from url: String) -> AnyPublisher<Data, NetworkError> {
        let remote = MovieImageRepositoryRemote(url: url)
        return remote.getData()
    }
    
    func getMovies() -> AnyPublisher<[Movie], NetworkError> {
        
        // verifying if storage has data saved
        if let timestamp = movieLocal?.getMovieTimeStamp() {
            let elapsedTime = Date().timeIntervalSince(timestamp)
            let cacheTime: TimeInterval = 5 * 60 // 5 minutes
            if elapsedTime > cacheTime {
                // force update
                // remove all local data
                movieLocal?.deleteAllMovies()
            }
        } else {
            // clean current data
            movieLocal?.deleteAllMovies()
        }
        
        let movies = (try? movieLocal?.getAllMovies()) ?? []
        
        if movies.isEmpty {
            return Future<[Movie], NetworkError> { [weak self] promise in
                guard let self = self else {
                    promise(.failure(NetworkError.serverError))
                    return
                }
                self.moviesRemote?
                    .getMovies()
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            promise(.failure(NetworkError.other(error)))
                        }
                    }
                    receiveValue: { movies in
                        self.movieLocal?.saveMovies(movies)
                        promise(.success(movies))
                    }
                    .store(in: &self.subscribers)
            }
            .eraseToAnyPublisher()
        }
        
        return CurrentValueSubject<[Movie], NetworkError>(movies.map { Movie($0) }).eraseToAnyPublisher()
    }
    
    func searchMovieByTitle(contains: String) -> [Movie] {
        guard let movies = try? movieLocal?.searchMovieByTitle(contains: contains) else {
            return []
        }
        return movies.map { Movie($0) }
    }
}
