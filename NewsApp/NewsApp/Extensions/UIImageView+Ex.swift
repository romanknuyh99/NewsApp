//
//  UIImageView+Ex.swift
//  NewsApp
//
//  Created by Roman Kniukh on 24.03.21.
//

import UIKit

extension String {
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: self),
                  let data = try? Data(contentsOf: url) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
    }
}
