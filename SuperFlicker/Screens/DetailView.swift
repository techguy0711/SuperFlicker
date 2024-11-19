//
//  DetailView.swift
//  SuperFlicker
//
//  Created by Kristhian De Oliveira on 11/19/24.
//

import SwiftUI

struct DetailView: View {
    var item: Item
    @StateObject var logic = FlickerLogic()
    
    init(item: Item) {
        self.item = item
    }
    
    private func handleDetailHTML() -> AttributedString {
        if let data = item.description.data(using: .utf8) {
            do {
                // Try to create an NSAttributedString from the HTML data
                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                
                return AttributedString(attributedString)
            } catch {
                return AttributedString()
            }
        }
        return AttributedString()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: item.media.m)) { image in
                    image.image?.resizable().scaledToFit()
                        .frame(height: 300)
                        .transition(.scale)
                        .accessibilityIdentifier(accessibilityIdentifiers.image.rawValue)
                        .accessibilityLabel(item.title)
                }
                Text(item.title)
                    .font(.largeTitle)
                    .accessibilityIdentifier(accessibilityIdentifiers.title.rawValue)
                Text(handleDetailHTML())
                    .font(.subheadline)
                    .lineLimit(3)
                    .accessibilityIdentifier(accessibilityIdentifiers.description.rawValue)
                Text("Author: \(item.author)")
                    .font(.caption)
                    .accessibilityIdentifier(accessibilityIdentifiers.author.rawValue)
                shareButton

            }
        }
        .sheet(isPresented: $logic.isSharing) {
            ShareSheet(activityItems: logic.activityItems)
                .onDisappear {
                    logic.isSharing = false // Reset the flag
                }
        }
    }
    
    var shareButton: some View {
        Button {
            logic.shareImage(from: item.media.m)
            logic.isSharing = true
        } label: {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .accessibilityLabel("Share")
                .accessibilityAddTraits(.isButton)
                .accessibilityRemoveTraits(.isImage)
                .accessibilityIdentifier(accessibilityIdentifiers.share.rawValue)
        }
    }
}

extension DetailView {
    enum accessibilityIdentifiers: String {
        case image = "flicker_detail_image"
        case title = "flicker_detail_title"
        case description = "flicker_detail_description"
        case author = "flicker_detail_author"
        case share = "flicker_detail_share"
    }
}

#Preview {
    ContentView()
}
