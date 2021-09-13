//
//  MovieViewModelTest.swift
//  MoviesTests
//
//  Created by Christian Quicano on 3/09/21.
//

import XCTest
@testable import Movies

class MovieViewModelTest: BaseRepositoryRemoteTest {
    
    var moviesRemote: MoviesRepositoryRemote!
    var repository: MovieRepository!
    var viewModel: MovieViewModel!
    
    override func setUpWithError() throws {
        moviesRemote = MoviesRepositoryRemote()
        repository = MovieRepository(moviesRemote: moviesRemote)
        viewModel = MovieViewModel(repository: repository)
    }
    
    func testGetMovies_Success() throws {
        // Given
        let fakeNetworkManager = try responseSuccess(json: "json_movies_success")
        fakeNetworkManager.successExpectation = Test.expec(self)
        moviesRemote.networkManager = fakeNetworkManager
        
        // When
        viewModel
            .moviesBinding
            .dropFirst()
            .sink { movies in
                XCTAssertNotNil(movies)
            }
            .store(in: &subscribers)
        
        viewModel.getMovies()
        
        // Then
        waitForExpectations(timeout: 1)
    }
    
    func testGetMovies_Failure() throws {
        // Given
        let fakeNetworkManager = responseFailure()
        fakeNetworkManager.failureExpectation = Test.expec(self)
        moviesRemote.networkManager = fakeNetworkManager
        
        // When
        viewModel
            .errorBinding
            .dropFirst()
            .sink(receiveValue: { error in
                XCTAssertNotNil(error)
            })
            .store(in: &subscribers)
        
        viewModel.getMovies()
        
        // Then
        waitForExpectations(timeout: 1)
    }
}
