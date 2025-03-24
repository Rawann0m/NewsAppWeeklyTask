//
//  ArticaleRow.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 24/09/1446 AH.
//
import SwiftUI
// Reusable component for displaying an article row
struct ArticleRow: View {
    let article: Article
    @ObservedObject var settingsViewModel: SettingsViewModel
    var body: some View {
        NavigationLink(destination: ArticleDetailView(article: article,settingsViewModel: SettingsViewModel())) {
            VStack(alignment: .leading) {
                // Display the image 
                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                }
                // Article title
                Text(article.title)
                    .font(.headline)
                // Article description
                Text(article.description ?? "No description")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
