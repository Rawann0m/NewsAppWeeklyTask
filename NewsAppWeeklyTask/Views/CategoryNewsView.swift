//
//  CategoryNewsView.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 22/09/1446 AH.
//
import SwiftUI

struct CategoryNewsView: View {
    let category: String
    @ObservedObject var settingsViewModel: SettingsViewModel
    @StateObject var viewModel = CategorizedNewsViewModel()
    
    var body: some View {
        NavigationStack{
            List {
                // Loop through articles for the selected category
                ForEach(viewModel.categorizedArticles[category] ?? [], id: \.id) { article in
                    ArticleRow(article: article, settingsViewModel: settingsViewModel)                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(category)
            .onAppear {
                // Fetch articles
                if viewModel.categorizedArticles[category]?.isEmpty ?? true {
                    viewModel.fetchCategorizedNews(for: category)
                }
            }
            //chnage the articles when we change the category
            .onChange(of: category) { oldCategory, newCategory in
                viewModel.fetchCategorizedNews(for: newCategory)
            }
            //handling errors
            .alert(isPresented: $viewModel.showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            //show that it is loading
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
        }.preferredColorScheme(settingsViewModel.isDarkMode ? .dark : .light)
    }
}

