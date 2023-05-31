//
//  Networking.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 30/05/2022.
//

import Foundation
import Combine

class Networking {
    
    func get <T: Codable> (url: String,
                           completion: @escaping (T) -> (),
                           onError: @escaping(Error) -> (),
                           onNoInternet: @escaping(Error) -> ()) {
        
        guard let url = URL(string: url) else {
            onError(CustomError.notFound)
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(decodedResponse)
                } catch {
                    onError(CustomError.notFound)
                }
            }
            if (error as? URLError)?.code == URLError.notConnectedToInternet {
                onNoInternet(CustomError.noInternetConnection)
            }
        }
        .resume()
    }
}

protocol CombineNetworking {
    var session: URLSession { get }
    func execute<T>(_ request: URLRequest, decodingType: T.Type, queue: DispatchQueue, retries: Int) -> AnyPublisher<T, Error> where T: Decodable
}

extension CombineNetworking {
    func execute<T>(_ request: URLRequest,
                    decodingType: T.Type,
                    queue: DispatchQueue = .main,
                    retries: Int = 0) -> AnyPublisher<T, Error> where T: Decodable {
        return session.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0 .response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw CustomError.notFound
                }
                return $0.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: queue)
            .retry(retries)
            .eraseToAnyPublisher()
    }
}

class NetworkingService: CombineNetworking {
    var session: URLSession

    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }

    convenience init() {
        self.init(configuration: .default)
    }
}

