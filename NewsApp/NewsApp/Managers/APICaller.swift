//
//  APICaller.swift
//  NewsApp
//
//  Created by Roman Kniukh on 22.03.21.
//

import Foundation

struct NewsManager {

    var onCompletion: ((NewsData) -> Void)?

    func fetchNews(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        let urlString = "https://newsapi.org/v2/everything?from=\(dateString)&apiKey=1ded1a063d524d619abcf8e4e43cead6&to=\(dateString)&sources=bbc-news&language=en&pageSize=100"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let newsData = parseJSON(withData: data) {
                    self.onCompletion?(newsData)
                }
            }
        }
        task.resume()
    }

    func parseJSON(withData data: Data) -> NewsData? {
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(NewsData.self, from: data)
            return data
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
