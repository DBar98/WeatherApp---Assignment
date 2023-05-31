//
//  FavouriteLocationsCoordinator.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 02/06/2022.
//

import UIKit
import CoreLocation

class FavouriteLocationsCoordinator: BaseNavigationCoordinatorType {
    
    var currentNavigationController: UINavigationController?
    
    func start() -> UINavigationController {
        
        guard let favouriteViewController = FavouriteLocationsViewController.instantiate() else {
            return UINavigationController()
        }
        
        favouriteViewController.viewModel = FavouriteLocationsViewModel(coordinator: self)
        let navigationController = UINavigationController(rootViewController: favouriteViewController)
        currentNavigationController = navigationController
        return navigationController
    }
}
