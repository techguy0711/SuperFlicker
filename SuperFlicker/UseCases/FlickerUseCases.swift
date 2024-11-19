//
//  FlickerUseCases.swift
//  SuperFlicker
//
//  Created by Kristhian De Oliveira on 11/19/24.
//

protocol FlickerUseCases {
    func searchPhotos(query: String) async
    func shareImage(from url: String)
}
