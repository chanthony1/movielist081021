//
//  MainCoordinator.swift
//  Movies
//
//  Created by Christian Quicano on 31/08/21.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController = UINavigationController()
    
    func start() {
        // create the first view
        let firstViewController = MoviesListViewController()
        firstViewController.coordinator = self
        navigationController.pushViewController(firstViewController, animated: false)
        navigationController.navigationBar.isTranslucent = false
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewcontroller = storyboard.instantiateViewController(identifier: "MoviesListViewController") as! MoviesListViewController
//        navigationController.pushViewController(viewcontroller, animated: false)
//        navigationController.navigationBar.isTranslucent = false
    }
    
    func showMovieDetails(with identifier: Int) {
        let detail = MovieDetailsViewController(movieId: identifier, coordinator: self)
        navigationController.pushViewController(detail, animated: true)
    }
    
    
}
