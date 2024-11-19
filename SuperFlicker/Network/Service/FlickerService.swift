//
//  FlickerService.swift
//  SuperFlicker
//
//  Created by Kristhian De Oliveira on 11/19/24.
//

import Foundation
import Combine

class FlickerService: FlickerServiceUseCases {
    
    let baseURL: URL = .init(string: "https://api.flickr.com/services/feeds/photos_public.gne")!
    
    func searchPhotos(for query: String) -> AnyPublisher<Flicker, Error> {
        //?format=json&nojsoncallback=1&tags=por
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            .init(name: "format", value: "json"),
            .init(name: "nojsoncallback", value: "1"),
            .init(name: "tags", value: query)
        ]
        guard let url = components.url else { fatalError() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: Flicker.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
