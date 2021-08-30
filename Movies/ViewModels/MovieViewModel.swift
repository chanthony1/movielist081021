//
//  MovieViewModel.swift
//  Movies
//
//  Created by Christian Quicano on 24/08/21.
//

import Foundation
import Combine
import CoreData

// Publisher
// Subscriber

// Subject = Publisher & Subscriber

protocol MovieViewModelType {
    var count: Int { get }
    var moviesBinding: Published<[Movie]>.Publisher { get }
    var errorBinding: Published<String>.Publisher { get }
    var updateRowBinding: Published<Int>.Publisher { get }
    func fetchMovies()
    func getTitle(at row: Int) -> String
    func getOverview(at row: Int) -> String
    func getImage(at row: Int) -> Data?
    func getMovieId(at row: Int) -> Int
}


class MovieViewModel: MovieViewModelType {
    // communication = closure, delegate/protocol, observer
    
    // MARK:- internal properties
    var moviesBinding: Published<[Movie]>.Publisher { $movies }
    var errorBinding: Published<String>.Publisher { $messageError }
    var updateRowBinding: Published<Int>.Publisher { $updateRow }
    
    @Published private var updateRow = 0
    @Published private var messageError = ""
    @Published private var movies = [Movie]()
    
    var count: Int { movies.count }
    func getTitle(at row: Int) -> String { movies[row].originalTitle }
    func getOverview(at row: Int) -> String { movies[row].overview }
    func getMovieId(at row: Int) -> Int { movies[row].identifier }
    
    // MARK:- private properties
    private let networkManager = NetworkManager()
    private var subscribers = Set<AnyCancellable>()
    private var imagesCache = [String: Data]()
    
    // MARK:- internal properties
    func fetchMovies() {
        
        // review cache rule
        // cache rule = every 5 minutes recall to the API
        if let cache = getCDCache() {
            let cacheTime: TimeInterval = 5 * 60 // 5 minutes
            let currentTime = Date()
            let timestamp = cache.timestamp ?? Date()
            let elapsedTime = currentTime.timeIntervalSince(timestamp)
            if elapsedTime > cacheTime {
                removeAllCache()
                removeAllMovies()
            }
        } else {
            removeAllMovies()
        }
        
        // see if I have data in CoreData
        let moviesStored = getAllMoviesFromCD()
        if !moviesStored.isEmpty {
            let temp = moviesStored.map { cdMovie in
                return Movie(cdMovie)
            }
            movies = temp
            return
        }
        
        
        // create the url
        let urlS = "https://api.themoviedb.org/3/movie/popular?api_key=6622998c4ceac172a976a1136b204df4&language=en-US"
        
        networkManager
            .getMovies(from: urlS)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.messageError = error.localizedDescription
                }
            } receiveValue: { [weak self] movies in
                self?.saveMovies(movies)
                self?.movies = movies
            }
            .store(in: &subscribers)
    }
    
    func getImage(at row: Int) -> Data? {
        
        let movie = movies[row]
        let posterPath = movie.posterPath
        
        if let data = imagesCache[posterPath] {
            return data
        }
        
        // search if I have the image in DataBase
        if let cdMovie = getCDMovie(with: movie.identifier),
           let imageData = cdMovie.imageData {
            // save image data into cache
            imagesCache[posterPath] = imageData
            return imageData
        }
        
        // download
        let urlS = "https://image.tmdb.org/t/p/w500\(posterPath)"
        networkManager
            .getImageData(from: urlS)
            .sink { _ in }
                receiveValue: { [weak self] data in
                    self?.imagesCache[posterPath] = data
                    self?.updateImageData(movieIdentifier: movie.identifier, imageData: data)
                    self?.updateRow = row
            }
            .store(in: &subscribers)

        return nil
    }
    
    // MARK: - private funcs
    private func getAllMoviesFromCD() -> [CDMovie] {
        let fetch: NSFetchRequest<CDCache> = CDCache.fetchRequest()
        let context = CoreDataManager.shared.mainContext
        let cache = try? context.fetch(fetch).first
        var movies = cache?.movies?.allObjects as? [CDMovie]
        movies = movies?.sorted(by: { m1, m2 in
            let d1 = m1.dateCreated ?? Date()
            let d2 = m2.dateCreated ?? Date()
            return d1 < d2
        })
        return movies ?? []
    }
    
    private func saveMovies(_ movies: [Movie]) {
        
        let context = CoreDataManager.shared.mainContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "CDCache", in: context)
        else { return }
        
        let cache = CDCache(entity: entity, insertInto: context)
        cache.timestamp = Date()
        
        for movie in movies {
            
            guard let entity = NSEntityDescription.entity(forEntityName: "CDMovie", in: context)
            else { continue }
            
            let cdMovie = CDMovie(entity: entity, insertInto: context)
            cdMovie.identifier = Int64(movie.identifier)
            cdMovie.originalTitle = movie.originalTitle
            cdMovie.overview = movie.overview
            cdMovie.posterPath = movie.posterPath
            cdMovie.dateCreated = Date()
            
            cache.addToMovies(cdMovie)
            
        }
        
        CoreDataManager.shared.saveContext(context)
    }
    
    private func updateImageData(movieIdentifier: Int, imageData: Data) {
        let context = CoreDataManager.shared.mainContext
        let movie = getCDMovie(with: movieIdentifier)
        movie?.imageData = imageData
        CoreDataManager.shared.saveContext(context)
    }
    
    private func getCDMovie(with identifier: Int) -> CDMovie? {
        let fetch: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CDMovie.identifier), "\(identifier)")
        fetch.predicate = predicate
        let context = CoreDataManager.shared.mainContext
        let movie = try? context.fetch(fetch).first
        return movie
    }
    
    private func getCDCache() -> CDCache? {
        let fetch: NSFetchRequest<CDCache> = CDCache.fetchRequest()
        let context = CoreDataManager.shared.mainContext
        let cache = try? context.fetch(fetch).first
        return cache
    }
    
    private func removeAllMovies() {
        let movies = getAllMoviesFromCD()
        let context = CoreDataManager.shared.mainContext
        for movie in movies {
            context.delete(movie)
        }
        CoreDataManager.shared.saveContext(context)
    }
    
    private func removeAllCache() {
        let fetch: NSFetchRequest<CDCache> = CDCache.fetchRequest()
        let context = CoreDataManager.shared.mainContext
        let caches = (try? context.fetch(fetch)) ?? []
        for cache in caches {
            context.delete(cache)
        }
        CoreDataManager.shared.saveContext(context)
    }
}
