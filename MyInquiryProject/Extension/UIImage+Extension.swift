//
//  UIImage+Extension.swift
//  MyInquiryProject
//
//  Created by Dương Thảnh Hải Trường Thọ on 12/17/16.
//  Copyright © 2016 ThoPhat. All rights reserved.
//

import UIKit

extension UIImageView {
    
    class func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    class func downloadImage(url: URL, withCompleteBlock completeHandler:@escaping ((UIImage?) -> Void)) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                guard let image = UIImage(data: data) else {
                    completeHandler(nil)
                    return
                }
                completeHandler(image)
            }
        }
    }
}
