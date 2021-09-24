//
//  Company.swift
//  MovieModule
//
//  Created by Christian Quicano on 14/09/21.
//

import Foundation

public struct Company: Decodable {
    public let id: Int
    public let logoPath: String?
    public let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
    }
}
