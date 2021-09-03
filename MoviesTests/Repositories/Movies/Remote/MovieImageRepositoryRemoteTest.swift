//
//  MovieImageRepositoryRemoteTest.swift
//  MoviesTests
//
//  Created by Christian Quicano on 3/09/21.
//

import XCTest
@testable import Movies

class MovieImageRepositoryRemoteTest: BaseRepositoryRemoteTest {
    
    var repository: MovieImageRepositoryRemote!
    
    override func setUpWithError() throws {
        repository = MovieImageRepositoryRemote()
    }

    func testGetData_Success() throws {
        // Given
        let fakeNetworkManager = try responseSuccess(json: "json_movies_success")
        fakeNetworkManager.successExpectation = Test.expec(self)
        repository.networkManager = fakeNetworkManager
        
        // When
        repository
            .getData()
            .sink { _ in }
                receiveValue: { data in
                XCTAssertNotNil(data)
            }
            .store(in: &subscribers)
        
        // Then
        waitForExpectations(timeout: 1)
    }
    
    func testGetData_Failure() throws {
        // Given
        let fakeNetworkManager = responseFailure()
        fakeNetworkManager.failureExpectation = Test.expec(self)
        repository.networkManager = fakeNetworkManager
        
        // When
        repository
            .getData()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                }
            },
            receiveValue: { data in
                XCTAssertNil(data)
            })
            .store(in: &subscribers)
        
        // Then
        waitForExpectations(timeout: 1)
    }
}
