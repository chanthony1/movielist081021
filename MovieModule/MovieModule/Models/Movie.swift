//
//  Movie.swift
//  MovieModule
//
//  Created by Christian Quicano on 14/09/21.
//

import Foundation

public struct Movie: Decodable {
    public let identifier: Int
    public let overview: String
    public let originalTitle: String
    public let posterPath: String
    public var imageData: Data?
    public var productionCompanies: [Company]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case overview
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
    }
    
    public init(id: Int = 0, posterPath: String = "", overview: String = "", originalTitle: String = "", imageData: Data? = nil) {
        self.identifier = id
        self.posterPath = posterPath
        self.overview = overview
        self.originalTitle = originalTitle
        self.imageData = imageData
    }
}
