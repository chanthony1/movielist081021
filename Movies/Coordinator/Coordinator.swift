//
//  Coordinator.swift
//  Movies
//
//  Created by Christian Quicano on 31/08/21.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
    func showMovieDetails(with identifier: Int)
}
