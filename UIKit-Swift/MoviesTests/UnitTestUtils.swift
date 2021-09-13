//
//  UnitTestUtils.swift
//  MoviesTests
//
//  Created by Christian Quicano on 3/09/21.
//

import Foundation
import XCTest

typealias Test = UnitTestUtils

class UnitTestUtils: Decodable {
    
    static func error(_ fileName: String = #file, _ lineNumber: Int = #line) -> NSError {
        let message = "Error at file:\(fileName) line:\(lineNumber)"
        return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }

    static func expec(_ testCase: XCTestCase, _ fileName: String = #file, _ lineNumber: Int = #line) -> XCTestExpectation {
        return testCase.expectation(description: "\(testCase) line:\(lineNumber)")
    }

    static func load(json: String, _ testCase: XCTestCase, _ fileName: String = #file, _ lineNumber: Int = #line) throws -> Data {
        let bundle = Bundle(for: UnitTestUtils.self)
        
        guard let file = bundle.url(forResource: json, withExtension: "json")
        else {
            fatalError("File \(json) could not be loaded for test case \(testCase)")
        }
        
        return try Data(contentsOf: file)
    }

    static func load(string: String, _ testCase: XCTestCase, _ fileName: String = #file, _ lineNumber: Int = #line) -> Data {

        if let stringData = string.data(using: .utf8) {
            return stringData
        } else {
            fatalError("String '\(string)' could not ve loaded for test case \(testCase)")
        }
    }
}

