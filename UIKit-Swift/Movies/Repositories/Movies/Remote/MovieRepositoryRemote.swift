//
//  MovieRepositoryRemote.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation
import Combine

class MovieRepositoryRemote: BaseRepositoryRemote {
    typealias T = Movie
    
    var url: String
    var networkManager: NetworkManager
    var decoder: JSONDecoder
    var subscribers: Set<AnyCancellable>
    
    required init(url: String = "",
                  networkManager: NetworkManager = MainNetworkManager.shared,
                  decoder: JSONDecoder = JSONDecoder(),
                  subscribers: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.url = url
        self.networkManager = networkManager
        self.decoder = decoder
        self.subscribers = subscribers
    }
    
}
