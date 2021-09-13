//
//  FakeNetworkManager.swift
//  MoviesTests
//
//  Created by Christian Quicano on 3/09/21.
//

import Foundation
import Combine

class FakeNetworkManager: NetworkManager {
    
    private var data: Data?
    private var error: NetworkError?
    
    init(data: Data? = nil, error: NetworkError? = nil) {
        self.data = data
        self.error = error
    }
    
    func get(from urlS: String) -> AnyPublisher<Data, NetworkError> {
        
        if let data = data {
            return CurrentValueSubject<Data, NetworkError>(data).eraseToAnyPublisher()
        }
        
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        fatalError("Bad configuration FakeNetworkManager")
    }
    
    
}
