//
//  MovieResponse.swift
//  MovieModule
//
//  Created by Christian Quicano on 14/09/21.
//

import Foundation

struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movie] //Array<Movie>
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }
    
}
