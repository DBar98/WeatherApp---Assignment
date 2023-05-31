//
//  MapViewModel.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 30/05/2022.
//

import MapKit

protocol MapViewModelInputs: BaseLocalizable {
    func showWeatherDetail(coordinates: CLLocationCoordinate2D, cityName: String)
    func showAlert(title: String, subtitle: String)
}

protocol MapViewModelOutputs{
    func showCurrentRegion(userCoordinates: CLLocationCoordinate2D, regionInMeters: Double) -> MKCoordinateRegion
}

protocol MapViewModelType {
    var inputs: MapViewModelInputs { get set }
    var outputs: MapViewModelOutputs { get set }
}

class MapViewModel: MapViewModelInputs, MapViewModelOutputs, MapViewModelType {
    
    var inputs: MapViewModelInputs { get { return self } set {} }
    var outputs: MapViewModelOutputs { get { return self } set {} }

    var coordinator: MapCoordinator?
    
    init(coordinator: MapCoordinator) {
        self.coordinator = coordinator
    }

    func showWeatherDetail(coordinates: CLLocationCoordinate2D, cityName: String) {
        coordinator?.showWeatherDetailView(coordinates: coordinates, cityName: cityName)
    }
    
    func showAlert(title: String, subtitle: String) {
        coordinator?.showAlert(title: title, subtitle: subtitle)
    }
    
    //MARK: - Outputs
     func showCurrentRegion(userCoordinates: CLLocationCoordinate2D, regionInMeters: Double) -> MKCoordinateRegion {
        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: userCoordinates.latitude,
                                                                            longitude: userCoordinates.longitude),
                                             latitudinalMeters: regionInMeters,
                                             longitudinalMeters: regionInMeters)
        return region
    }
}

