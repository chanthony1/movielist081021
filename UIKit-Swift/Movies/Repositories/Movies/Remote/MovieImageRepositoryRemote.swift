//
//  MovieImageRepositoryRemote.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation
import Combine

struct ImageResponse: Decodable { }

class MovieImageRepositoryRemote: BaseRepositoryRemote {
    
    typealias T = ImageResponse
    
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
    
    func getData() -> AnyPublisher<Data, NetworkError> {
        self.networkManager.get(from: url)
    }
}
