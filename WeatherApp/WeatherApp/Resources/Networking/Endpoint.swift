//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 04/07/2022.
//

import Foundation

protocol Endpoint {

    var baseUrl: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var apiKey: String {
        return "5812eab85768560512e01cf2c3ff3eb8"
    }

    var urlComponents: URLComponents {
        var components = URLComponents(string: baseUrl)
        components?.queryItems = queryItems
//        components?.query = apiKey
        print(queryItems)
        print(components)

        return components!
    }

    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}
