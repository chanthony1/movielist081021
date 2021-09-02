//
//  Movie.swift
//  Movies
//
//  Created by Christian Quicano on 23/08/21.
//

import Foundation

struct Movie: Decodable {
    let identifier: Int
    let overview: String
    let originalTitle: String
    let posterPath: String
    var imageData: Data?
    var productionCompanies: [Company]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case overview
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
    }
    
    init(_ movie: CDMovie) {
        identifier = Int(movie.identifier)
        overview = movie.overview ?? ""
        originalTitle = movie.originalTitle ?? ""
        posterPath = movie.posterPath ?? ""
        imageData = movie.imageData
    }
    
    init(id: Int = 0, posterPath: String = "", overview: String = "", originalTitle: String = "", imageData: Data? = nil) {
        self.identifier = id
        self.posterPath = posterPath
        self.overview = overview
        self.originalTitle = originalTitle
        self.imageData = imageData
    }
}
