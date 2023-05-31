//
//  BaseNavigationCoordinator.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 03/06/2022.
//

import UIKit
import CoreLocation

protocol BaseNavigationCoordinatorType {
    
    var currentNavigationController: UINavigationController? { get set }
    func start() -> UINavigationController
    func showWeatherDetailView(coordinates: CLLocationCoordinate2D, cityName: String)
}

extension BaseNavigationCoordinatorType {
    func showWeatherDetailView(coordinates: CLLocationCoordinate2D, cityName: String) {
        guard let currentNavigationController = currentNavigationController else {
            return
        }

        let weatherDetailCoordinator = WeatherDetailCoordinator()
        weatherDetailCoordinator.start(parent: currentNavigationController, coordinates: coordinates, cityName: cityName)
    }
}

