//
//  NewsDetails.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 22/09/1446 AH.
//
import SwiftUI
import SafariServices

struct ArticleDetailView: View {
    let article: Article
    @ObservedObject var settingsViewModel: SettingsViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Article Image
                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                }
                
                // Article Title
                Text(article.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // Article content
                Text(article.content ?? "No content")
                    .font(.subheadline)
                    .padding(.horizontal)
                
                Spacer()
                HStack{
                    // Article author
                    Text(article.author ?? "No author")
                        .font(.subheadline)
                        .padding()
                    
                    // Article date
                    Text(article.publishedAt)
                        .font(.subheadline)
                        .padding()
                    Spacer()
                }
                // Button to open the full article
                Button(action: {
                    openArticleURL()
                }) {
                    Text("Read Full Article")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
        }
        .navigationTitle("Article Details")
        .preferredColorScheme(settingsViewModel.isDarkMode ? .dark : .light)
    }
    
    // Function to open the article URL
    private func openArticleURL() {
        if let url = URL(string: article.url) {
            // Open the URL in Safari
            UIApplication.shared.open(url)
        }
    }
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailView(
            article: DeveloperPreview.instance.newsVM.allArticles.first!, // Pass a single article
            settingsViewModel: SettingsViewModel() // Provide a mock SettingsViewModel
        )
    }
}
