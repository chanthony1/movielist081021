//
//  FakeNetworkManager.swift
//  MoviesTests
//
//  Created by Christian Quicano on 3/09/21.
//

import XCTest
import Combine
@testable import Movies

class FakeNetworkManager: NetworkManager {
    
    var successExpectation: XCTestExpectation?
    var failureExpectation: XCTestExpectation?
    
    private var data: Data?
    private var error: NetworkError?
    
    init(data: Data? = nil, error: NetworkError? = nil) {
        self.data = data
        self.error = error
    }
    
    func get(from urlS: String) -> AnyPublisher<Data, NetworkError> {
        
        if let data = data {
            successExpectation?.fulfill()
            return CurrentValueSubject<Data, NetworkError>(data).eraseToAnyPublisher()
        }
        
        if let error = error {
            failureExpectation?.fulfill()
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        fatalError("Bad configuration FakeNetworkManager")
    }
    
    
}
