
//
//  Untitled.swift
//  SuperFlicker
//
//  Created by Kristhian De Oliveira on 11/19/24.
//

import Foundation
import Combine

protocol FlickerServiceUseCases {
    func searchPhotos(for query: String) -> AnyPublisher<Flicker, Error>
}
