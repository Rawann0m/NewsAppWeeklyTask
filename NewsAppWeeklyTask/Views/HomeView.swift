//
//  HomeView.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 22/09/1446 AH.
//
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = NewsViewModel()
    @ObservedObject var settingsViewModel: SettingsViewModel
 var body: some View {
        GeometryReader { geometry in
            NavigationStack {
//                ZStack{
//                    // Background Image
//                    Image(settingsViewModel.isDarkMode ? "background1" : "background2")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: .infinity,height: .infinity)
//                        .edgesIgnoringSafeArea(.all)
                List {
                    // Show all the articles
                    ForEach(viewModel.allArticles) { article in
                        ArticleRow(article: article, settingsViewModel: settingsViewModel)                    }
                    
                    // Show a "Load More" button if there are more articles to load
                    if viewModel.allArticles.count < viewModel.totalArticles {
                        Button(action: {
                            viewModel.fetchNews() // Fetch the next page of articles
                        }) {
                            HStack {
                                Spacer()
                                if viewModel.isLoading {
                                    ProgressView() // Show a loading spinner
                                } else {
                                    Text("Load More") // "Load More" button
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black)
                                        .cornerRadius(10)
                                }
                                Spacer()
                            }
                            .padding(.vertical)
                        }
                    }
                }
//                .scrollContentBackground(.hidden)
//                        .listRowBackground(Color.clear)
                    .navigationTitle("News")
                    .onAppear {
                        // Fetch the first page of data when the view appears
                        if viewModel.allArticles.isEmpty {
                            viewModel.fetchNews()
                        }
                    }
                    .alert(isPresented: $viewModel.showErrorAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text(viewModel.errorMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    .overlay {
                        if viewModel.isLoading {
                            ProgressView("Loading...")
                        }
                    }
           // }
            }
            .preferredColorScheme(settingsViewModel.isDarkMode ? .dark : .light)
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(
//            viewModel: DeveloperPreview.instance.newsVM, // Use the preview data
//            settingsViewModel: SettingsViewModel()
//        )
//    }
//}



