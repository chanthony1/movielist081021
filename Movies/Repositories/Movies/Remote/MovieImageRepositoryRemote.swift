//
//  MovieImageRepositoryRemote.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation
import Combine
import Alamofire

class MovieImageRepositoryRemote {
    
    var url: String
    var networkManager: NetworkManager
    var decoder: JSONDecoder
    
    private var subscribers = Set<AnyCancellable>()
    
    init(url: String = "",
         networkManager: NetworkManager = NetworkManager.shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.url = url
        self.networkManager = networkManager
        self.decoder = decoder
    }
    
    func getData() -> AnyPublisher<Data, NetworkError> {
        self.networkManager.get(from: url)
    }
}
