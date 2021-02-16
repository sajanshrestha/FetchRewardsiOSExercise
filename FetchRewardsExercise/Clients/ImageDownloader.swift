//
//  ImageDownloader.swift
//  FetchRewardsExercise
//
//  Created by Sajan Shrestha on 2/15/21.
//

import UIKit

struct ImageDownloader {
    
    static func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
        }.resume()
    }
}
