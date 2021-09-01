//
//  BaserepositoryRemote.swift
//  Movies
//
//  Created by Christian Quicano on 1/09/21.
//

import Foundation
import Combine

class BaseRepositoryRemote<T: Decodable> {
    
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
    
    func getData() -> AnyPublisher<T, NetworkError> {
        
        return Future<T, NetworkError> { [weak self] promise in
            guard let self = self else { return }
            self.networkManager
                .get(from: self.url)
                .decode(type: T.self, decoder: self.decoder)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(Result.failure(NetworkError.other(error)))
                    }
                }
                receiveValue: { data in
                    promise(.success(data))
                }
                .store(in: &self.subscribers)
        }
        .eraseToAnyPublisher()

    }
    
}
