//
//  BaseLocationViewModel.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 03/06/2022.
//

import CoreLocation

protocol BaseLocalizable {
    func addressByReverseGeocoding(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?) -> Void, onError: @escaping (String) -> ())
}

extension BaseLocalizable {
    func addressByReverseGeocoding(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?) -> Void, onError: @escaping (String) -> ()) {
        let address = CLGeocoder.init()
        
        address.reverseGeocodeLocation(CLLocation.init(latitude: latitude, longitude: longitude)) { (places, error) in
            guard error == nil else {
                onError(CustomError.reverseGeocodingFailed.localizedDescription)
                return
            }
            
            guard let places = places?[0] else {
                onError(CustomError.reverseGeocodingFailed.localizedDescription)
                return
            }
            completion(places)
        }
    }
}

class BaseLocationViewModel {
    
}
