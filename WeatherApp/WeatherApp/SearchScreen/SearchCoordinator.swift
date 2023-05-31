//
//  SearchCoordinator.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 31/05/2022.
//

import UIKit
import CoreLocation

class SearchCoordinator: BaseNavigationCoordinatorType {
    
    var currentViewController: SearchViewController?
    var currentNavigationController: UINavigationController?
    
    func start() -> UINavigationController {
        guard let controller = SearchViewController.instantiate() else {
            return UINavigationController()
        }
        let navigationViewController = UINavigationController(rootViewController: controller)
        currentViewController = controller
        currentViewController?.viewModel = SearchViewModel(coordinator: self)
        currentNavigationController = navigationViewController
        return navigationViewController
    }
}
