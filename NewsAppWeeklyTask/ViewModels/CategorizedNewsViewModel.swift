//
//  CategorizedNewsViewModel.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 22/09/1446 AH.
//
import Foundation
import Alamofire
import Combine

class CategorizedNewsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var allArticles: [Article] = []
    @Published var currentPage: Int = 1
    @Published var totalArticles: Int = 0
    //to be able to Implement both URLSession and Alamofire i thought it might be better to switch between the two whenever i want
    var useAlamofire: Bool = true
    
    // Dictionary to store articles by category
    @Published var categorizedArticles: [String: [Article]] = [
        "Business": [],
        "Technology": [],
        "Finance": [],
        "Automotive": []
    ]
    
    
    
    // Fetch news for a specific category
    func fetchCategorizedNews(for category: String) {
        if isLoading { return }
        
        print("Fetching news for category: \(category)...")
        
        isLoading = true
        let dispatchGroup = DispatchGroup()
        
        // Mapping of categories to API URLs
        let categoryAPIMapping: [String: [String]] = [
            "Technology": [
                "https://newsapi.org/v2/top-headlines?sources=techcrunch&pageSize=10&\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89",
                "https://newsapi.org/v2/everything?q=apple&from=2025-03-21&to=2025-03-21&sortBy=popularity&pageSize=10&\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89",
                "https://newsapi.org/v2/everything?q=tesla&from=2025-03-22&sortBy=publishedAt&pageSize=10&page=\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89"
            ],
            "Business": [
                "https://newsapi.org/v2/top-headlines?country=us&category=business&pageSize=10&\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89",
                "https://newsapi.org/v2/everything?q=apple&from=2025-03-21&to=2025-03-21&sortBy=popularity&pageSize=10&\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89",
                "https://newsapi.org/v2/everything?q=tesla&from=2025-03-22&sortBy=publishedAt&pageSize=10&page=\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89",
                "https://newsapi.org/v2/everything?domains=wsj.com&pageSize=10&\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89"
            ],
            "Finance": [
                "https://newsapi.org/v2/everything?domains=wsj.com&pageSize=10&\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89"
            ],
            "Automotive": [
                "https://newsapi.org/v2/everything?q=tesla&from=2025-03-22&sortBy=publishedAt&pageSize=10&page=\(currentPage)&apiKey=fe24dbf8ea434d89a5c230b1e88c8c89"
            ]
        ]
        
        // Get the list of URLs for the selected category
        guard let urls = categoryAPIMapping[category] else {
            print("No URLs found for category: \(category)")
            return
        }
        
        for url in urls {
            dispatchGroup.enter()
            
            print("\n=============================")
            print("🌍 API REQUEST INITIATED")
            print("🔗 URL: \(url)")
            print("🛠 Method: GET")
            print("=============================\n")
            
            if useAlamofire {
                // Use Alamofire
                AF.request(url, method: .get)
                    .validate()
                    .responseDecodable(of: NewsResponse.self) { response in
                        DispatchQueue.main.async {
                            print("\n=============================")
                            print("📡 API RESPONSE RECEIVED")
                            print("🔗 URL: \(url)")
                            print("📄 Status Code: \(response.response?.statusCode ?? -1)")
                            print("=============================")
                            
                            switch response.result {
                            case .success(let data):
                                // If the request is successful, add articles to the list
                                if let articles = data.articles {
                                    self.categorizedArticles[category]?.append(contentsOf: articles)
                                    self.totalArticles = data.totalResults
                                    print("\n✅ SUCCESS: Data Fetched")
                                    print(" Articles: \(articles.count) articles using Alamofire")
                                    print("=============================\n")
                                }
                            case .failure(let error):
                                // If the request fails, show an error message
                                self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                                self.showErrorAlert = true
                                print("\n❌ ERROR: Failed to fetch data")
                                print("⚠️ Error Description: \(error.localizedDescription) from \(url)")
                            }
                            dispatchGroup.leave()
                        }
                    }
            } else {
                // Use URLSession 
                fetchWithURLSession(url: url) { articles, totalResults in
                    DispatchQueue.main.async {
                        if let articles = articles {
                            self.categorizedArticles[category]?.append(contentsOf: articles)
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
            print("Finished fetching. Total articles for \(category): \(self.categorizedArticles[category]?.count ?? 0)")
        }
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
