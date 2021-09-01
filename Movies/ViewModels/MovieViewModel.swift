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

class MovieViewModel {
    
    // MARK: - private properties
    private let repository: MovieRepository
    private var subscribers = Set<AnyCancellable>()
    private var imagesCache = [String: Data]()
    @Published private var movies = [Movie]()
    @Published private var errorMessage = ""
    @Published private var movie = Movie()
    @Published private var companiesLoaded = false
    
    // MARK: - internal properties
    var moviesBinding: Published<[Movie]>.Publisher { $movies }
    var errorBinding: Published<String>.Publisher { $errorMessage }
    var movieBinding: Published<Movie>.Publisher { $movie }
    var companiesLoadedBinding: Published<Bool>.Publisher { $companiesLoaded }
    var count: Int { movies.count }
    var companiesCount: Int { movie.productionCompanies?.count ?? 0 }
    var movieTitle: String { movie.originalTitle }
    var movieOverview: String { movie.overview }
    
    // MARK: - init
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    // MARK: - internal funcs
    func getDetailMovie(by identifier: Int) {
        repository
            .getDetailMovie()?
            .sink { _ in }
                receiveValue: { [weak self] movie in
                    self?.movie = movie
                    self?.downloadImagesCompanies(from: movie.productionCompanies)
            }
            .store(in: &subscribers)

    }
    
    func getMovies() {
        repository
            .getMovies()
            .sink { _ in }
                receiveValue: { [weak self] movies in
                    guard let self = self else { return }
                    self.movies = movies
            }
            .store(in: &subscribers)
    }
    
    func getImageData(at row: Int) -> Data? {
        let movie = movies[row]
        let posterPath = movie.posterPath
        
        guard !posterPath.isEmpty
        else { return nil }
        
        guard let data = movie.imageData else {
            // download image
            let imagePath = NetworkUrl.baseImageUrl.appending(posterPath)
            repository
                .downloadImage(from: imagePath)
                .sink { _ in }
                    receiveValue: { [weak self] data in
                        guard let self = self else { return }
                        self.repository.updateImageMovie(data, by: movie.identifier)
                        self.updateImageData(data, at: row)
                }
                .store(in: &subscribers)
            return nil
        }
        
        return data
    }
    
    func getMovieImageData(by identifier: Int) -> Data? {
        guard let movie = repository.searchMovieBy(identifier)
        else { return nil }
        return movie.imageData
    }
    
    func getTitle(at row: Int) -> String { movies[row].originalTitle }
    
    func getCompanyName(at row: Int) -> String? { movie.productionCompanies?[row].name }
    
    func getCompanyImageData(at row: Int) -> Data? {
        guard let logoPath = movie.productionCompanies?[row].logoPath
        else { return nil }
        return imagesCache[logoPath]
    }
    
    func getOverview(at row: Int) -> String { movies[row].overview }
    
    func getMovieId(at row: Int) -> Int { movies[row].identifier }
    
    func filterMovies(by text: String) {
        
        guard !text.isEmpty else {
            getMovies()
            return
        }
        
        // Search in Core Data
        movies = repository.searchMovieByTitle(contains: text)
        
    }
    
    // MARK: - private funcs
    private func updateImageData(_ data: Data, at row: Int) {
        var temp = [Movie]()
        for (index, movie) in movies.enumerated() {
            var movie = movie
            movie.imageData = index == row ? data : movie.imageData
            temp.append(movie)
        }
        movies = temp
    }
    
    // use this method to download images from the movie image, I use the companies array from the movie detail
    private func downloadImagesCompanies(from companies: [Company]?) {
        guard let companies = companies else { return }
    
        let group = DispatchGroup()
        
        for company in companies {
            guard let logoPath = company.logoPath else { continue }
            let url = NetworkUrl.baseImageUrl.appending(logoPath)
            
            group.enter()
            
            repository
                .downloadImage(from: url)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    group.leave()
                }
                receiveValue: { [weak self] data in
                    guard let self = self else { return }
                    self.imagesCache[logoPath] = data
                }
                .store(in: &subscribers)
        }
        
        group.notify(queue: DispatchQueue.global()) { [weak self] in
            self?.companiesLoaded = true
        }
    }
}
