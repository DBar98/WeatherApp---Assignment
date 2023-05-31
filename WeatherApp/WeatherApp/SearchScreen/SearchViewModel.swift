//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 02/06/2022.
//

import CoreLocation

protocol SearchViewModelInputs {
    func showWeatherDetail(coordinates: CLLocationCoordinate2D, cityName: String)
}

protocol SearchViewModelType {
    var inputs: SearchViewModelInputs { get set }
}

class SearchViewModel: SearchViewModelInputs, SearchViewModelType {
    
    var inputs: SearchViewModelInputs { get { return self } set {} }
    
    var coordinator: SearchCoordinator?
    
    init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
    }
    
    func showWeatherDetail(coordinates: CLLocationCoordinate2D, cityName: String) {
        coordinator?.showWeatherDetailView(coordinates: coordinates, cityName: cityName)
    }
}
