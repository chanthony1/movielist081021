//
//  NetworkUrl.swift
//  MovieModule
//
//  Created by Christian Quicano on 14/09/21.
//

import Foundation

public enum NetworkUrl {
    static private let baseURL = "https://api.themoviedb.org/3"
    static private let apiKey = "?api_key=6622998c4ceac172a976a1136b204df4"
    static private let language = "&language=en-US"
    
    public static let baseImageUrl = "https://image.tmdb.org/t/p/w500"
    public static let moviesPopular = "\(baseURL)/movie/popular\(apiKey)\(language)"
    public static let keyMovieId = "$MOVIE_ID$"
    public static let movieDetail = "\(baseURL)/movie/\(keyMovieId)\(apiKey)\(language)"
}
