//
//  ContentView.swift
//  SuperFlicker
//
//  Created by Kristhian De Oliveira on 11/19/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var logic = FlickerLogic()
    @State private var searchText: String = ""
    
    let columns = [
        GridItem(.flexible()), // Flexible column width
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            switch logic.state {
            case .initial:
                EmptyView()
            case .loading:
                Spacer()
                ProgressView()
                    .progressViewStyle(.linear)
                Spacer()
            case .success(let data):
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(data.items, id: \.id) { image in
                            NavigationLink(destination: DetailView(item: image)) {
                                AsyncImage(url: URL(string: image.media.m)) { photo in
                                    photo.image?.resizable().scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .accessibilityIdentifier(accessibilityIdentifiers.image.rawValue)
                                        .accessibilityLabel(image.title)
                                }
                                .accessibilityAddTraits(.isButton)
                                .accessibilityRemoveTraits(.isImage)
                            }
                        }
                    }
                }
            case .failure:
                Text("Error")
            }
        }
        .searchable(text: $searchText, placement: .automatic, prompt: "Search Flicker!")
        .onChange(of: searchText) {
            if !searchText.isEmpty {
                Task {
                    await logic.searchPhotos(query: searchText)
                }
            }
        }
        
        .onSubmit {
            if !searchText.isEmpty {
                Task {
                    await logic.searchPhotos(query: searchText)
                }
            }
        }
    }
}

extension ContentView {
    enum accessibilityIdentifiers: String {
        case image = "flicker_home_image"
    }
}

#Preview {
    ContentView()
}
