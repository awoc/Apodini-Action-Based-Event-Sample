//
//  NetworkManager+Networking.swift
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import Combine


// MARK: NetworkManager
/// A `NetworkManager` handles the HTTP based network Requests to a server
enum NetworkManager {
    /// The `AnyCancellable`s that are used to track network requests made by the `NetworkManager`
    static var cancellables: Set<AnyCancellable> = []
    /// The default `Authorization` header field for requests made by the `NetworkManager`
    static var authorization: String?
    
    /// The `JSONEncoder` that is used to encode request bodies to JSON
    static var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    /// The `JSONDecoder` that is used to decode response bodies to JSON
    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    
    /// Creates a `URLRequest` based on the parameters that has the `Content-Type` header field set to `application/json`
    /// - Parameters:
    ///   - method: The HTTP method
    ///   - url: The `URL` of the `URLRequest`
    ///   - authorization: The value that should be added the `Authorization` header field
    ///   - body: The HTTP body that should be added to the `URLRequest`
    /// - Returns: The created `URLRequest`
    static func urlRequest(_ method: String,
                           url: URL,
                           authorization: String? = authorization,
                           body: Data? = nil) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authorization = authorization {
            urlRequest.addValue(authorization, forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.httpBody = body
        
        return urlRequest
    }
    
    static func getElement<Element: Decodable>(on route: URL,
                                               authorization: String? = authorization) -> AnyPublisher<Element, Error> {
        print("The Element ist \(RESTResponse<Element>.self)")
        return URLSession.shared.dataTaskPublisher(for:
                                                    urlRequest("GET", url: route, authorization: authorization)
        )
        .map(\.data)
        .decode(type: RESTResponse<Element>.self, decoder: decoder)
        .receive(on: DispatchQueue.main)
        .map(\.data)
        .eraseToAnyPublisher()
    }
    
    static func getElements<Element: Decodable>(on route: URL,
                                                authorization: String? = authorization) -> AnyPublisher<[Element], Error> {
        getElement(on: route, authorization: authorization)
            .eraseToAnyPublisher()
    }
    
    static func get<Element: Decodable>(on route: URL,
                                        _ element: Element.Type,
                                        authorization: String? = authorization) -> AnyPublisher<Element, Error> {
        print()
        return getElement(on: route, authorization: authorization)
            .eraseToAnyPublisher()
    }
    
    static func post<T: Codable>(_ element: T,
                                 authorization: String? = authorization,
                                 on route: URL) {
        let request = urlRequest("POST", url: route, authorization: authorization, body: try? encoder.encode(element))
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("error \(error)")
                return
            }
            print("Sent data")
        }
        task.resume()
    }
    
    static func postElement<Element: Codable>(_ element: Element,
                                              authorization: String? = authorization,
                                              on route: URL) -> AnyPublisher<Element, Error> {
        URLSession.shared.dataTaskPublisher(for:
                                                urlRequest("POST", url: route, authorization: authorization, body: try? encoder.encode(element))
        )
        .map(\.data)
        .decode(type: RESTResponse<Element>.self, decoder: decoder)
        .map(\.data)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    static func putElement<T: Codable>(_ element: T,
                                       authorization: String? = authorization,
                                       on route: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for:
                                                urlRequest("PUT", url: route, authorization: authorization, body: try? encoder.encode(element))
        )
        .map(\.data)
        .decode(type: T.self, decoder: NetworkManager.decoder)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    static func delete(at route: URL,
                       authorization: String? = authorization) -> AnyPublisher<Void, Error> {
        URLSession.shared.dataTaskPublisher(for:
                                                urlRequest("DELETE", url: route, authorization: authorization)
        )
        .tryMap { _, response in
            guard let response = response as? HTTPURLResponse, 200..<299 ~= response.statusCode else {
                throw URLError(.cannotRemoveFile)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
