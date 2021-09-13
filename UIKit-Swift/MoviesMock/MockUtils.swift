//
//  MockUtils.swift
//  MoviesMock
//
//  Created by Christian Quicano on 9/09/21.
//

import Foundation

typealias Mock = MoviesMock

class MoviesMock {
    
    static func error(message: String? = nil, _ fileName: String = #file, _ lineNumber: Int = #line) -> NetworkError {
        let finalMessage = message ?? "Error at file:\(fileName) line:\(lineNumber)"
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: finalMessage])
        return NetworkError.other(error)
    }

    static func load(json: String, _ fileName: String = #file, _ lineNumber: Int = #line) throws -> Data {
        let bundle = Bundle(for: MoviesMock.self)
        
        guard let file = bundle.url(forResource: json, withExtension: "json")
        else { fatalError("File \(json) could not be loaded") }
        
        return try Data(contentsOf: file)
    }

    static func load(string: String, _ fileName: String = #file, _ lineNumber: Int = #line) -> Data {

        if let stringData = string.data(using: .utf8) {
            return stringData
        } else {
            fatalError("String '\(string)' could not be loaded")
        }
    }
}
