//
//  NetworkError.swift
//  MovieModule
//
//  Created by Christian Quicano on 14/09/21.
//

import Foundation

public enum NetworkError: Error {
    case url
    case other(Error)
    case serverError
}
