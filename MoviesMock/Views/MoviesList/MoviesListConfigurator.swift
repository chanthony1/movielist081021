//
//  MoviesListConfigurator.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation

class MovieListConfigurator {
    
    static func configure(view: MoviesListViewController) {
        
        // get arguments
        let arguments = ProcessInfo.processInfo.arguments
        
        // delete all coredata
        try? CoreDataManager.shared.deleteAll()
        
        // validating arguments
        if arguments.contains(keyLaunchMoviesScreenWithError) {
            let error = Mock.error()
            
            // Assembling of ViewModel
            let fakeNetworkManager = FakeNetworkManager(data: nil, error: error)
            assemblingViewModel(view: view, networkManager: fakeNetworkManager)
            return
        }
        
        guard let data = try? Mock.load(json: "json_movies_success")
        else { fatalError("Can not load json") }
        
        // Assembling of ViewModel
        let fakeNetworkManager = FakeNetworkManager(data: data, error: nil)
        assemblingViewModel(view: view, networkManager: fakeNetworkManager)
    }
    
    private static func assemblingViewModel(view: MoviesListViewController, networkManager: NetworkManager) {
        let moviesRemote = MoviesRepositoryRemote(url: NetworkUrl.moviesPopular, networkManager: networkManager)
        let movieLocal = MovieRepositoryLocal()
        let repository = MovieRepository(moviesRemote: moviesRemote, movieLocal: movieLocal)
        let viewModel = MovieViewModel(repository: repository)
        view.viewModel = viewModel
    }
    
}
