//
//  MapCoordinator.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 30/05/2022.
//

import UIKit

class MapCoordinator: BaseNavigationCoordinatorType {
    
    weak var currentViewController: MapViewController?
    weak var currentNavigationController: UINavigationController?
    
    func start() -> UINavigationController {
        
        guard let controller = MapViewController.instantiate() else {
            return UINavigationController()
        }
        controller.viewModel = MapViewModel(coordinator: self)
        let navigationViewController = UINavigationController(rootViewController: controller)
        currentViewController = controller
        currentNavigationController = navigationViewController
        return navigationViewController
    }
    
    func showAlert(title: String, subtitle: String) {
        let alert = UIAlertController.showAlertWithCancelButton(title: title,
                                                    message: subtitle)
        DispatchQueue.main.async { [weak self] in
            self?.currentViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
