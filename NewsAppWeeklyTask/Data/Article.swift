//
//  Article.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 26/09/1446 AH.
//
import SwiftUI

struct Article: Codable, Identifiable {
    let id = UUID()
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case author
        case title
        case description
        case url
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content
        case source
    }
}
