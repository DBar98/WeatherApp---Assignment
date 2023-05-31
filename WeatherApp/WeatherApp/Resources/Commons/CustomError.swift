//
//  APIError.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 04/06/2022.
//
import Foundation

enum CustomError: Error {
    case locationServicesUnable
    case notFound
    case databaseSaveFailed
    case databaseGetFailed
    case reverseGeocodingFailed
    case noInternetConnection
    // Throw in all other cases
    case unexpected(code: Int)
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .locationServicesUnable:
            return ErrorStrings.locationServicesUnable
        case .notFound:
            return ErrorStrings.notFound
        case .databaseSaveFailed:
            return ErrorStrings.databaseSaveFailed
        case .databaseGetFailed:
            return ErrorStrings.databaseGetFailed
        case .reverseGeocodingFailed:
            return ErrorStrings.reverseGeocodingFailed
        case .noInternetConnection:
            return ErrorStrings.noInternetConnection
        case .unexpected(_):
            return ErrorStrings.unexpected
        }
    }
}
