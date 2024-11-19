//
//  FlickerServiceMock.swift
//  SuperFlicker
//
//  Created by Kristhian De Oliveira on 11/19/24.
//

import Foundation
import Combine

class FlickerServiceMock: FlickerServiceUseCases {
    var didCallSearchFunc: Bool = false
    func searchPhotos(for query: String) -> AnyPublisher<Flicker, any Error> {
        didCallSearchFunc = true
        return URLSession.shared.dataTaskPublisher(for: URL(string: "")!)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: Flicker.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()

    }
}
