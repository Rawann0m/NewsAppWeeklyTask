//
//  NewsViewModel.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 22/09/1446 AH.
//
import Foundation
import Alamofire
import Combine

class NewsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var allArticles: [Article] = []
    @Published var currentPage: Int = 1
    @Published var totalArticles: Int = 0
    
    //to be able to Implement both URLSession and Alamofire i thought it might be better to switch between the two whenever i want
    var useAlamofire: Bool = true
    
    
    // Fetch all news articles
    func fetchNews() {
        if isLoading { return }
        
        print("Fetching news for page \(currentPage)...")
        
        isLoading = true // Show loading
        var fetchedArticles: [Article] = []
        let dispatchGroup = DispatchGroup()
        // List of API URLs
        let urls = [
            "https://newsapi.org/v2/everything?q=apple&from=2025-03-21&to=2025-03-21&sortBy=popularity&pageSize=10&page=\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89",
            "https://newsapi.org/v2/everything?q=tesla&from=2025-03-22&sortBy=publishedAt&pageSize=10&page=\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89",
            "https://newsapi.org/v2/top-headlines?country=us&category=business&pageSize=10&page=\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89",
            "https://newsapi.org/v2/top-headlines?sources=techcrunch&pageSize=10&page=\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89",
            "https://newsapi.org/v2/everything?domains=wsj.com&pageSize=10&page=\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89"
        ]
        // Loop through each API URL
        for url in urls {
            dispatchGroup.enter()
            
            if useAlamofire {
                // Use Alamofire
                AF.request(url, method: .get)
                    .validate() // Ensure the response is valid
                    .responseDecodable(of: NewsResponse.self) { response in
                        DispatchQueue.main.async {
                            switch response.result {
                            case .success(let data):
                                // If the request is successful, add articles to the list
                                if let articles = data.articles {
                                    fetchedArticles.append(contentsOf: articles)
                                    self.totalArticles = data.totalResults
                                    print("Fetched \(articles.count) articles using Alamofire")
                                }
                            case .failure(let error):
                                // If the request fails, show an error message
                                self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                                self.showErrorAlert = true
                                print("Error fetching data: \(error.localizedDescription) from \(url)")
                            }
                            dispatchGroup.leave()
                        }
                    }
            } else {
                // Use URLSession
                fetchWithURLSession(url: url) { articles, totalResults in
                    DispatchQueue.main.async {
                        if let articles = articles {
                            fetchedArticles.append(contentsOf: articles)
                            self.totalArticles = totalResults
                            print("Fetched \(articles.count) articles using URLSession")
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        // Notify when all tasks are done
        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
            // Sort articles by date (most recent first)
            self.allArticles.append(contentsOf: self.sortArticlesByDate(fetchedArticles))
            self.currentPage += 1
            print("Finished fetching. Total articles: \(self.allArticles.count)")
        }
    }
    
    // Sort articles by date (most recent first)
    private func sortArticlesByDate(_ articles: [Article]) -> [Article] {
        return articles.sorted { $0.publishedAt > $1.publishedAt }
    }
    
    // Fetch data using URLSession
    func fetchWithURLSession(url: String, completion: @escaping ([Article]?, Int) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil, 0)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
                completion(nil, 0)
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                    self.showErrorAlert = true
                }
                completion(nil, 0)
                return
            }
            
            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(newsResponse.articles, newsResponse.totalResults)
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
                completion(nil, 0)
            }
        }
        
        task.resume()
    }
}
