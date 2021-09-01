//
//  Company.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation

struct Company: Decodable {
    let id: Int
    let logoPath: String?
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
    }
}
