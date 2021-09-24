//
//  MoviesListViewModelType.swift
//  MovieModule
//
//  Created by Christian Quicano on 14/09/21.
//

import Foundation
import Combine

public protocol MoviesListViewModelType {
    var networkManager: NetworkManager { get }
    var movies: [Movie] { get }
    var urlMovies: String { get }
    var subscribers: Set<AnyCancellable> { get }
    func getMovies()
}
