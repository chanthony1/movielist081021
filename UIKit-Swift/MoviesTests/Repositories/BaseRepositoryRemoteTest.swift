//
//  BaseRepositoryRemoteTest.swift
//  MoviesTests
//
//  Created by Christian Quicano on 3/09/21.
//

import XCTest
import Combine
@testable import Movies

class BaseRepositoryRemoteTest: XCTestCase {
    
    var subscribers = Set<AnyCancellable>()
    
    func responseSuccess(json: String) throws -> FakeNetworkManager {
        let data = try Test.load(json: json, self)
        let networkManager = FakeNetworkManager(data: data, error: nil)
        return networkManager
    }
    
    func responseSuccess(string: String) -> FakeNetworkManager {
        let data = Test.load(string: string, self)
        let networkManager = FakeNetworkManager(data: data, error: nil)
        return networkManager
    }
    
    func responseFailure(error: NetworkError = NetworkError.other(Test.error())) -> FakeNetworkManager {
        let networkManager = FakeNetworkManager(data: nil, error: error)
        return networkManager
    }

}
