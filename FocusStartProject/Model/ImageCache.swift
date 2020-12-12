//
//  ImageCache.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import Foundation
import UIKit

class ImageCache{
    
    static func storeImage(urlString:String,
                           image:UIImage,
                           nameOfPicture:String){
        DispatchQueue.global(qos: .userInitiated).async {
            let path = NSTemporaryDirectory().appending(nameOfPicture)
            let url = URL(fileURLWithPath: path)
            
            let data = image.jpegData(compressionQuality: 0.1)
            try? data?.write(to: url)
            
            var dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String]
            if dict == nil{
                dict = [String:String]()
            }
            dict![urlString] = path
            UserDefaults.standard.set(dict, forKey: "ImageCache")
        }
    }
    
    static func loadImage(urlString:String,
                          nameOfPicture:String,
                          completion: @escaping (String, UIImage?)->Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String] {
                if let path = dict[urlString] {
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                        let image = UIImage(data: data)
                        completion(urlString, image)
                        return
                    }
                }
            }
            guard let url = URL(string: urlString) else {
                assertionFailure("oops, something went wrong")
                return
            }
            
            // TODO: - на другой поток!!!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard  error == nil else { return }
                guard let data = data else { return }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        storeImage(urlString: urlString,
                                   image: image,
                                   nameOfPicture: nameOfPicture)
                        completion(urlString, image)
                    }
                }
            }
            task.resume()
        }
    }
}
