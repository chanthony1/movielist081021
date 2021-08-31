//
//  NetworkManager.swift
//  Movies
//
//  Created by Christian Quicano on 23/08/21.
//

import Foundation
import Combine
import Alamofire

class NetworkManager {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    func getMovies(from urlS: String) -> AnyPublisher<[Movie], NetworkError> {
        
        guard let url = URL(string: urlS) else {
            return Fail(error: .url).eraseToAnyPublisher()
        }
        
        print("Calling to: \(urlS)")
        
        return session
            .dataTaskPublisher(for: url)
            .map { $0.0 }
            .decode(type: MoviesResponse.self, decoder: decoder)
            .map { $0.results }
            .mapError({ _ in
                return NetworkError.serverError
            })
            .eraseToAnyPublisher()
        
    }
    
    func getImageData(from urlS: String) -> AnyPublisher<Data, NetworkError> {
        
        guard let url = URL(string: urlS) else {
            return Fail(error: .url).eraseToAnyPublisher()
        }
        
        print("Calling to: \(urlS)")
        
        return Future<Data, NetworkError> { promise in
            
            AF.request(url, method: .get).response { response in
                if let error = response.error {
                    promise(.failure(NetworkError.other(error)))
                }
                if let data = response.data {
                    promise(.success(data))
                }
            }
            
        }.eraseToAnyPublisher()
        
        
        
        
        
//        return session
//            .dataTaskPublisher(for: url)
//            .map { $0.data }
//            .mapError({ _ in
//                return NetworkError.serverError
//            })
//            .eraseToAnyPublisher()
    }
    
}
