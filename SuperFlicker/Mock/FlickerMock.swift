//
//  FlickerMock.swift
//  SuperFlicker
//
//  Created by Kristhian De Oliveira on 11/19/24.
//

import Foundation

class FlickerMock: FlickerUseCases {
    var didCallSearch: Bool = false
    var didCallShare: Bool = false
    func searchPhotos(query: String) async {
        didCallSearch = true
    }
    
    func shareImage(from url: String) {
        didCallShare = true
    }
}
