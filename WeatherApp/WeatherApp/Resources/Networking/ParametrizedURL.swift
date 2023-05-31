//
//  ParametrizedURL.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 30/05/2022.
//

import Foundation

enum PathVariable: String {
    case current = "hourly,minutely,daily"
    case forecasts = "hourly,minutely"
}

struct ParametrizedURL {
    
    static let baseURL = "https://api.openweathermap.org/data/2.5/onecall?"
    static let accessToken = "5812eab85768560512e01cf2c3ff3eb8"
    
    let lat: String
    let long: String
    let pathVariable: PathVariable
    
    init(
        lat: String,
        long: String,
        pathVariable: PathVariable) {
            self.lat = lat
            self.long = long
            self.pathVariable = pathVariable
    }
    
    var url: String {
        get {
            return ParametrizedURL.baseURL + parsePathVariables() + ParametrizedURL.accessToken
        }
    }
    
    func parsePathVariables() -> String {
        let currentLanguageIdentifier = Locale.current.identifier
        let languageShortcut = currentLanguageIdentifier.components(separatedBy: "-")[0]
        
        return "lat=\(lat)&lon=\(long)&exclude=\(pathVariable.rawValue)&units=metric&lang=\(languageShortcut)&appid="
    }
}

class WeatherDataUrl: Endpoint {


    var forecastType: PathVariable
    let lat: String
    let long: String

    var baseUrl: String {
        return "https://api.openweathermap.org/data/2.5/onecall?"
    }

    var path: String {
        switch forecastType {
        case .current:
            return "hourly,minutely,daily"
        case .forecasts:
            return "hourly,minutely"
        }
    }

    var queryItems: [URLQueryItem] {
        let currentLanguageIdentifier = Locale.current.identifier
        let languageShortcut = currentLanguageIdentifier.components(separatedBy: "-")[0]

        return [URLQueryItem(name: "lat", value: lat),
                URLQueryItem(name: "lon", value: long),
                URLQueryItem(name: "exclude", value: forecastType.rawValue),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "lang", value: languageShortcut),
                URLQueryItem(name: "appid", value: apiKey)]
    }
    
    init(forecastType: PathVariable,
         lat: String,
         long: String) {
        self.forecastType = forecastType
        self.lat = lat
        self.long = long
    }
}

