//
//  PreviewProvider.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 24/09/1446 AH.
//
import Foundation
import SwiftUI
//make an extention of the preview so i can do the preview every time in each view without having to deal wwith the preview needing an article info
extension PreviewProvider{
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}


class DeveloperPreview{
    static let instance = DeveloperPreview()
    //as long as the init is private then we make suree no one can make the instance of this class from anywhere else but from within the class itself
    private init(){ }
    let newsVM: NewsViewModel = {
            let vm = NewsViewModel()
            vm.allArticles = [
                Article(
                    source: Source(id: nil, name: "Example News"),
                    author: "John Doe",
                    title: "Breaking News: Swift is Amazing!",
                    description: "SwiftUI makes UI development smooth and efficient.",
                    url: "https://ExampleNews.com",
                    urlToImage: "https://adictosaltrabajo.com/wp-content/uploads/2020/05/swiftUI-banner-1024x576-1.jpg",
                    publishedAt: "2025-03-24T07:36:31Z",
                    content: "Swift is a powerful and intuitive programming language..."
                ),
                Article(
                    source: Source(id: nil, name: "Tech Times"),
                    author: "Jane Smith",
                    title: "AI Advancements in 2025",
                    description: "New breakthroughs in artificial intelligence are reshaping technology.",
                    url: "https://techtimes.com",
                    urlToImage: "https://assets.everspringpartners.com/dims4/default/fb976e9/2147483647/strip/true/crop/686x360+171+0/resize/1200x630!/quality/90/?url=http%3A%2F%2Feverspring-brightspot.s3.us-east-1.amazonaws.com%2Fdf%2Fee%2F106592af4d508f76b29662e456db%2Fadvanced-ai.jpg",
                    publishedAt: "2025-03-24T08:15:00Z",
                    content: "Artificial intelligence continues to evolve, enabling..."
                )
            ]
            vm.totalArticles = 2
            return vm
        }()
    }
