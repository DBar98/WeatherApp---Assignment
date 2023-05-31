//
//  WeatherDetailCoordinator.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 01/06/2022.
//

import UIKit
import MapKit

protocol WeatherDetailCoordinatorType {
    func start(parent: UINavigationController, coordinates: CLLocationCoordinate2D, cityName: String)
}

class WeatherDetailCoordinator: WeatherDetailCoordinatorType {
    
    func start(parent: UINavigationController, coordinates: CLLocationCoordinate2D, cityName: String) {
        guard let controller = WeatherDetailViewController.instantiate() else { return }
        
        controller.navigationItem.title = cityName
        controller.viewModel = WeatherDetailViewModel(networking: Networking(), coordinates: coordinates)
        parent.pushViewController(controller, animated: true)
    }
}
