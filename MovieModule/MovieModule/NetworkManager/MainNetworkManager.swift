//
//  MainNetworkManager.swift
//  MovieModule
//
//  Created by Christian Quicano on 14/09/21.
//

import Foundation
import Alamofire
import Combine

public class MainNetworkManager: NetworkManager {
    
    public static let shared = MainNetworkManager()
    
    private init() { }
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    public func get(from urlS: String) -> AnyPublisher<Data, NetworkError> {
        
        guard let url = URL(string: urlS) else {
            return Fail(error: .url).eraseToAnyPublisher()
        }
        
        print("Calling to: \(urlS)")
        
        return Future<Data, NetworkError> { promise in
            
            AF.request(url, method: .get)
                .response { response in
                    if let error = response.error {
                        promise(.failure(NetworkError.other(error)))
                    }
                    if let data = response.data {
                        promise(.success(data))
                    }
                }
            
        }.eraseToAnyPublisher()
        
    }
    
}
