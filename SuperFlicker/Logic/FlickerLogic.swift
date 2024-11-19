//
//  FlickerModel.swift
//  SuperFlicker
//
//  Created by Kristhian De Oliveira on 11/19/24.
//

import Foundation
import Combine
import UIKit

enum FlickerState {
    case initial
    case loading
    case success(Flicker)
    case failure(Error)
}

class FlickerLogic: ObservableObject, FlickerUseCases {
    @Published var state: FlickerState = .initial
    @Published var isSharing: Bool = false
    @Published var activityItems: [Any] = []

    private var cancellables: Set<AnyCancellable> = []
    
    let flickerService: FlickerService
    
    init(flickerService: FlickerService = FlickerService()) {
        self.flickerService = flickerService
    }
    
    func searchPhotos(query: String) async {        
        flickerService.searchPhotos(for: query)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    self.state = .failure(error)
                    print(error.localizedDescription)
                }
            } receiveValue: { value in
                self.state = .success(value)
            }
            .store(in: &cancellables)
            
    }
    
    func shareImage(from url: String) {
            // Convert the URL string to a URL object
            guard let imageURL = URL(string: url) else {
                print("Invalid URL")
                return
            }

            // Download the image data
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                // Check for errors or missing data
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                // Convert the data to an image
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.activityItems = [image]
                        self.isSharing = true // Trigger the share sheet
                    }
                } else {
                    print("Failed to create image from data")
                }
            }.resume()
        }
}
