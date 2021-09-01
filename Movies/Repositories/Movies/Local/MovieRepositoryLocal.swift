//
//  MovieRepositoryLocal.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation
import CoreData

class MovieRepositoryLocal {
    
    let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func getMovieTimeStamp() -> Date? {
        let fetch: NSFetchRequest<CDCache> = CDCache.fetchRequest()
        let context = coreDataManager.mainContext
        let cache = try? context.fetch(fetch).first
        return cache?.timestamp
    }
    
    func getAllMovies() throws -> [CDMovie] {
        // get the last timestamp
        let context = coreDataManager.mainContext
        let fetch: NSFetchRequest<CDCache> = CDCache.fetchRequest()
        let cache = try context.fetch(fetch).first
        let moviesArray = cache?.movies?.allObjects as? [CDMovie]
        let moviesSorted = moviesArray?.sorted(by: { m1, m2 in
            let d1 = m1.dateCreated ?? Date()
            let d2 = m2.dateCreated ?? Date()
            return d1 < d2
        })
        return moviesSorted ?? []
    }
    
    func deleteAllMovies() {
        let context = coreDataManager.mainContext
        
        context.perform { [weak self] in
            guard let self = self else { return }
            let fetch: NSFetchRequest<CDCache> = CDCache.fetchRequest()
            let caches = try? context.fetch(fetch)
            for cache in caches ?? [] {
                context.delete(cache)
            }
            
            // delete all movies
            let fetchMovies: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
            let movies = (try? context.fetch(fetchMovies)) ?? []
            for movie in movies {
                context.delete(movie)
            }
            
            self.coreDataManager.saveContext(context)
        }
    }
    
    func saveMovies(_ movies: [Movie]) {
        // create a cache
        let context = coreDataManager.mainContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "CDCache", in: context)
        else { fatalError("Can not create entity desription") }
        
        context.perform { [weak self] in
            let cache = CDCache(entity: entity, insertInto: context)
            cache.timestamp = Date()
            // creating movies
            for movie in movies {

                guard let entity = NSEntityDescription.entity(forEntityName: "CDMovie", in: context)
                else { fatalError("Can not create entity desription") }
                
                let newMovie = CDMovie(entity: entity, insertInto: context)
                newMovie.identifier = Int64(movie.identifier)
                newMovie.originalTitle = movie.originalTitle
                newMovie.overview = movie.overview
                newMovie.posterPath = movie.posterPath
                newMovie.dateCreated = Date()
                
                cache.addToMovies(newMovie)
            }
            
            self?.coreDataManager.saveContext(context)
        }
    }
    
    func updateImageMovie(_ data: Data, by identifier: Int) {
        let fetch: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CDMovie.identifier), "\(identifier)")
        fetch.predicate = predicate
        
        let context = coreDataManager.mainContext
        context.perform { [weak self] in
            let movie = try? context.fetch(fetch).first
            movie?.imageData = data
            self?.coreDataManager.saveContext(context)
        }
        
    }
    
    func searchMovieByTitle(contains string: String) throws -> [CDMovie] {
        let fetch: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        
        let predicateTitle = NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(CDMovie.originalTitle), string)
        let predicateOverview = NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(CDMovie.overview), string)
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateTitle, predicateOverview])
        
        // use [c] for case sensitive searching
        fetch.predicate = predicate
        let context = coreDataManager.mainContext
        return try context.fetch(fetch)
    }
    
    func getMovie(_ identifier: Int) -> CDMovie? {
        let fetch: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CDMovie.identifier), "\(identifier)")
        fetch.predicate = predicate
        let context = coreDataManager.mainContext
        let movie = try? context.fetch(fetch).first
        return movie
    }
}
