//
//  ImageCache.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import Foundation
import UIKit

class ImageCache{
    static func storeImage(urlString: String,
                           image: UIImage,
                           nameOfPicture: String) {
        // Загружаем картинку в NSTemporaryDirectory,
        // записываем dictionary с URL изображения в UserDefaults для возможности
        // посмотреть сохранено ли уже это изображение в при последующей загрузки
        // этой же картинки
        DispatchQueue.global(qos: .userInitiated).async {
            let path = NSTemporaryDirectory().appending(nameOfPicture)
            let url = URL(fileURLWithPath: path)
            
            let data = image.jpegData(compressionQuality: 0.1)
            try? data?.write(to: url)
            
            var dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String]
            if dict == nil {
                dict = [String:String]()
            }
            guard var dictionary = dict else {
                assertionFailure("ooops!")
                return
            }
            dictionary[urlString] = path
            UserDefaults.standard.set(dictionary, forKey: "ImageCache")
        }
    }
    
    static func loadImage(urlString: String,
                          nameOfPicture: String,
                          completion: @escaping (String, UIImage?)->Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String] {
                if let path = dict[urlString] {
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                        DispatchQueue.main.async {
                            let image = UIImage(data: data)
                            completion(urlString, image)
                        }
                        return
                    }
                }
            }
            guard let url = URL(string: urlString) else {
                DispatchQueue.main.async {
                    completion(urlString, AppConstants.Images.errorImage)
                }
                assertionFailure("oops, something went wrong")
                return
            }


            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard  error == nil else {
                    DispatchQueue.main.async {
                        completion(urlString, AppConstants.Images.errorImage)
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(urlString, AppConstants.Images.errorImage)
                    }
                    return
                }

                if let image = UIImage(data: data) {
                    storeImage(urlString: urlString,
                               image: image,
                               nameOfPicture: nameOfPicture)
                    DispatchQueue.main.async {
                        completion(urlString, image)
                    }
                } else {
                    // Не удалось получить картинку, возвращаем пустое изображение
                    DispatchQueue.main.async {
                        completion(urlString, AppConstants.Images.errorImage)
                    }
                }
            }
            task.resume()
        }
    }
}
