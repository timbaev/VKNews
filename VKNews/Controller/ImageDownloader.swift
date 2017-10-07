//
//  ImageDownloader.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 04.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit

class ImageDownloader {
 
    static func loadImageAsync(imageURL: URL, indexPath: IndexPath, imageNumber: Int, completionHandlet handler: @escaping (_ success: Bool, _ image: UIImage?, _ indexPath: IndexPath, _ imageNumber: Int) -> Void) {
        URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    handler(true, UIImage(data: data), indexPath, imageNumber)
                }
            }
        }).resume()
    }
    
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        
        if let imageURL = URL(string: link) {
            URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    self.contentMode = contentMode
                    if let data = data { self.image = UIImage(data: data) }
                }
            }).resume()
        }
    }
}
