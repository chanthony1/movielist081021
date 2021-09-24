//
//  NetworkManager.swift
//  MovieModule
//
//  Created by Christian Quicano on 14/09/21.
//

import Foundation
import Combine

public protocol NetworkManager {
    func get(from urlS: String) -> AnyPublisher<Data, NetworkError>
}
