//
//  AppStrings.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 04/06/2022.
//

import Foundation

struct AppStrings {
    static let favourites = "Favourites".localized()
    static let search = "Search".localized()
    static let map = "Map".localized()
    static let feelsLike = "Feels like".localized()
    static let addToFavourites = "Add to favourites".localized()
    static let removeFromFavourites = "Remove from favourites".localized()
}

struct ErrorStrings {
    static let error = "Error".localized()
    static let connectionError = "Connection Error".localized()
    static let locationServicesUnable = "Location services on the device are not allowed.".localized()
    static let notFound = "The specified data could not be found.".localized()
    static let databaseSaveFailed = "Unable to add data to favourites.".localized()
    static let databaseGetFailed = "Unable to show favourite locations.".localized()
    static let reverseGeocodingFailed = "Unable to display location name.".localized()
    static let noInternetConnection = "Please try again later or check the Internet settings on your device.".localized()
    static let unexpected = "An unexpected error occurred.".localized()
}
