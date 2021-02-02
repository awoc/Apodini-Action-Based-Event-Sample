//
//  Restful.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import Combine


// MARK: Restful
/// A Restful Element that can be created, read, updated, and deleted from a Restful Server
protocol Restful: Codable & Identifiable {
    /// The route that should be used to retrieve and store the RESTful Element from the Server
    static var route: URL { get }
    
    
    /// Gets the elements from the RESTful Server
    static func get() -> AnyPublisher<[Self], Error>
    
    /// Deletes the element from the Restful Server
    static func delete(id: Self.ID) -> AnyPublisher<Void, Error>
    
    
    /// Posts the element to the Restful Server
    func post() -> AnyPublisher<Self, Error>
    
    /// Puts the element to the Restful Server
    func put() -> AnyPublisher<Self, Error>
}


// MARK: Restful
extension Restful where Self.ID == UUID? {
    static func get() -> AnyPublisher<[Self], Error> {
        NetworkManager.getElements(on: Self.route)
            .eraseToAnyPublisher()
    }
    
    
    func post() -> AnyPublisher<Self, Error> {
        NetworkManager.postElement(self, on: Self.route)
            .eraseToAnyPublisher()
    }
}


// MARK: Restful + Identifiable UUID
extension Restful where Self.ID == UUID? {
    static func delete(id: Self.ID) -> AnyPublisher<Void, Error> {
        NetworkManager.delete(at: Self.route.appendingPathComponent(id?.uuidString ?? ""))
    }
    
    func put() -> AnyPublisher<Self, Error> {
        NetworkManager.putElement(self, on: Self.route.appendingPathComponent(self.id?.uuidString ?? ""))
            .eraseToAnyPublisher()
    }
}

struct RESTResponse<Element: Decodable>: Decodable {
    var data: Element
}
