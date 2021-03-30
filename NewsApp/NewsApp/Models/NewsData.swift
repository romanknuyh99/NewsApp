//
//  NewsData.swift
//  NewsApp
//
//  Created by Roman Kniukh on 22.03.21.
//

import Foundation
 //MARK: - NewsData
struct NewsData: Codable {
    let status: String
    let articles: [FallableDecodable<Article>]
}

// MARK: - Article
struct Article: Codable {
    let title: String
    let articleDescription: String
    let urlToImage: String?
    let publishedAt: String 

    enum CodingKeys: String, CodingKey {
        case title
        case articleDescription = "description"
        case urlToImage, publishedAt
    }
}

