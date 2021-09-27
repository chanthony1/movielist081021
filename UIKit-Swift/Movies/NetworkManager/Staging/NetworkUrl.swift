//
//  NetworkUrl.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation

enum NetworkUrl {
    static private let baseURL = "https://test.api.themoviedb.org/3"
    static private let apiKey = "?api_key=6622998c4ceac172a976a1136b204df4"
    static private let language = "&language=en-US"
    
    static let baseImageUrl = "https://image.tmdb.org/t/p/w500"
    static let moviesPopular = "\(baseURL)/movie/popular\(apiKey)\(language)"
    static let keyMovieId = "$MOVIE_ID$"
    static let movieDetail = "\(baseURL)/movie/\(keyMovieId)\(apiKey)\(language)"
}
