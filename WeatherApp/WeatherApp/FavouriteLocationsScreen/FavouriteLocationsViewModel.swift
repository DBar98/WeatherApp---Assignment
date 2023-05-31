//
//  FavouriteLocationsViewModel.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 02/06/2022.
//

import CoreLocation

protocol FavouriteLocationsViewModelInputs {
    func getFavouritesLocations()
    func showWeatherDetail(coordinates: CLLocationCoordinate2D, cityName: String)
}

protocol FavouriteLocationsViewModelOutputs {
    var onLocationFound: (([FavouriteLocation]) -> ())? { get set }
    var onNoDataFound: ((String) -> ())? { get set }

}

protocol FavouriteLocationsViewModelType {
    var inputs: FavouriteLocationsViewModelInputs { get set }
    var outputs: FavouriteLocationsViewModelOutputs { get set }
}

class FavouriteLocationsViewModel: FavouriteLocationsViewModelInputs, FavouriteLocationsViewModelOutputs, FavouriteLocationsViewModelType {
        
    var inputs: FavouriteLocationsViewModelInputs { get { return self } set {} }
    var outputs: FavouriteLocationsViewModelOutputs { get { return self } set {} }

    var coordinator: FavouriteLocationsCoordinator?
    var onLocationFound: (([FavouriteLocation]) -> ())?
    var onNoDataFound: ((String) -> ())?
    var databaseManager: DatabaseManager = DatabaseManager.shared
    
    init(coordinator: FavouriteLocationsCoordinator) {
        self.coordinator = coordinator
    }
    
    func getFavouritesLocations() {
        do {
            let locations = try databaseManager.getAllItems()
            onLocationFound?(locations)
        } catch {
            onNoDataFound?(error.localizedDescription)
        }
    }
    
    func showWeatherDetail(coordinates: CLLocationCoordinate2D, cityName: String) {
        coordinator?.showWeatherDetailView(coordinates: coordinates, cityName: cityName)
    }
}
