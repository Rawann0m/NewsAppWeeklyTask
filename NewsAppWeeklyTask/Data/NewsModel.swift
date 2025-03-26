//
//  NewsModel.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 22/09/1446 AH.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]?
}



