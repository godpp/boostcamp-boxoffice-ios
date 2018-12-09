//
//  Extension.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 09/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: Optional Binding using Generic
    func safe<T>(_ data: T?) -> T {
        switch data{
        case is Int:
            guard let unlock = data else { return 0 as! T }
            return unlock
        case is Double:
            guard let unlock = data else { return 0.0 as! T }
            return unlock
        case is String:
            guard let unlock = data else { return "" as! T }
            return unlock
        default:
            return data!
        }
    }
    
    func downloadImage(url: String) -> UIImage?{
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)
            }
        }
        return UIImage()
    }
}
