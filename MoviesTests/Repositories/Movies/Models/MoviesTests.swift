//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Christian Quicano on 2/09/21.
//

import XCTest
@testable import Movies

class MoviesTests: XCTestCase {
    
    func testMoviesResponse() throws {
        let data = try Test.load(json: "json_movies_success", self)
        let response = try JSONDecoder().decode(MoviesResponse.self, from: data)
        let totalOfResults = response.results.count
        XCTAssertEqual(totalOfResults, 20, "Failed. It must be equal")
    }
}
