//
//  ImageDownloading.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 15/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

protocol ImageDownloading {
    func downloadImage(url: String) -> UIImage?
}

extension ImageDownloading where Self: UIViewController {
    
    func downloadImage(url: String) -> UIImage?{
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)
            }
        }
        return UIImage()
    }
}
