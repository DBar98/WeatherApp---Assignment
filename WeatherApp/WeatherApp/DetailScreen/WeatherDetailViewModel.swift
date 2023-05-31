//
//  DetailViewModel.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 30/05/2022.
//

import CoreLocation
import Combine

protocol WeatherDetailViewModelInputs {
    func fetchForecastData(pathVariable: PathVariable)
    func findLocationByCityName(cityName: String) -> FavouriteLocation?
    func saveLocation(locationName: String)
    func deleteLocation(location: FavouriteLocation)
    func fetchForecastDataCombine() -> AnyPublisher <ForecastData, Error>
}

protocol WeatherDetailViewModelOutputs {
    var onWeatherDataFetch: ((ForecastData) -> ())? { get set }
    var onError: ((String) -> ())? { get set }
    var onNoInteretConnection: ((String) -> ())? { get set }
}

protocol WeatherDetailViewModelType {
    var inputs: WeatherDetailViewModelInputs { get set }
    var outputs: WeatherDetailViewModelOutputs { get set }
}

class WeatherDetailViewModel: WeatherDetailViewModelInputs, WeatherDetailViewModelOutputs, WeatherDetailViewModelType, BaseLocalizable {
    
    var inputs: WeatherDetailViewModelInputs { get { return self } set {} }
    var outputs: WeatherDetailViewModelOutputs { get { return self } set {} }
    var onWeatherDataFetch: ((ForecastData) -> ())?
    var onError: ((String) -> ())?
    var onNoInteretConnection: ((String) -> ())?
    
    private let networking: Networking
    private let coordinates: CLLocationCoordinate2D
    private let databaseManager = DatabaseManager.shared
    static let favouritesChanged = "weather.app.favourites.change"
    
    init(networking: Networking, coordinates: CLLocationCoordinate2D) {
        self.networking = networking
        self.coordinates = coordinates
    }
    
    //MARK: - Data Fetching
    func fetchForecastData(pathVariable: PathVariable) {
        let lat = String(coordinates.latitude)
        let long = String(coordinates.longitude)
        
        let url: String = ParametrizedURL(lat: lat,
                                          long: long,
                                          pathVariable: pathVariable).url

        networking
            .get(url: url,
                 completion: { [weak self] (data: ForecastData) in
                self?.onWeatherDataFetch?(data)
            }, onError: { [weak self] error in
                self?.onError?(error.localizedDescription)
            }, onNoInternet: { [weak self] connectionError in
                self?.onNoInteretConnection?(connectionError.localizedDescription)
            })
    }

    //MARK: - Data Fetching Combine
    func fetchForecastDataCombine() -> AnyPublisher <ForecastData, Error> {
        let lat = String(coordinates.latitude)
        let long = String(coordinates.longitude)
        let networkingService = NetworkingService()

        return networkingService.execute(WeatherDataUrl(forecastType: .current,
                                                        lat: lat,
                                                        long: long).request,
                                  decodingType: ForecastData.self)
    }
    
    //MARK: - Database Management
    func findLocationByCityName(cityName: String) -> FavouriteLocation? {
        let favourites = try? databaseManager.getAllItems()
        guard let favourites = favourites else {
            return nil
        }
        
        return favourites.filter { item in
            item.locationName == cityName
        }.first
    }
    
    func saveLocation(locationName: String) {
        let lat = coordinates.latitude
        let long = coordinates.longitude
        
        addressByReverseGeocoding(latitude: lat,
                                  longitude: long,
                                  completion: { [weak self] foundPlace in
            
            guard let self = self, let country = foundPlace?.country else { return }
            do {
                try self.databaseManager.saveItem(long: long,
                                                  lat: lat,
                                                  locationName: locationName,
                                                  locationCountry: country)
                NotificationCenter.default.post(name: Notification.Name(WeatherDetailViewModel.favouritesChanged),
                                                object: nil)
            } catch {
                self.onError?(error.localizedDescription)
            }
        }, onError: { error in
            print(error)
        })
    }
    
    func deleteLocation(location: FavouriteLocation) {
        databaseManager.deleteItem(item: location)
        NotificationCenter.default.post(name: Notification.Name(WeatherDetailViewModel.favouritesChanged),
                                        object: nil)
    }
}
