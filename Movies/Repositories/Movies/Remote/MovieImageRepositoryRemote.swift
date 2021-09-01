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
        
        
        
        
        
        
        return Future<Data, NetworkError> { [weak self] promise in
            guard let self = self else { return }
            
            AF.request(self.url, method: .get).response { response in
                if let error = response.error {
                    promise(.failure(NetworkError.other(error)))
                }
                if let data = response.data {
                    promise(.success(data))
                }
            }
            
//            self.networkManager
//                .get(from: self.url)
//                .sink { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        promise(Result.failure(NetworkError.other(error)))
//                    }
//                }
//                receiveValue: { data in
//                    promise(.success(data))
//                }
//                .store(in: &self.subscribers)
            
        }.eraseToAnyPublisher()
    }
}
