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
    
    func presentActionSheet(_ title: String, _ message: String, completion: @escaping (_ orderType: Int) -> ()) {
        let optionMenu = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let sortReservationAction = UIAlertAction(
            title: "예매율",
            style: .default,
            handler: { (alert: UIAlertAction!) -> Void in
                completion(0)
        })
        
        let sortCurationAction = UIAlertAction(
            title: "큐레이션",
            style: .default,
            handler: { (alert: UIAlertAction!) -> Void in
                completion(1)
        })
        let sortDateAction = UIAlertAction(
            title: "개봉일",
            style: .default,
            handler: { (alert: UIAlertAction!) -> Void in
                completion(2)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        optionMenu.addAction(sortReservationAction)
        optionMenu.addAction(sortCurationAction)
        optionMenu.addAction(sortDateAction)
        optionMenu.addAction(cancelAction)
        present(optionMenu, animated: true, completion: nil)
    }
    
    func setTitle(_ title: String){
        self.navigationItem.title = title
    }
    
    func getTitleByOrderType(_ orderType: Int) -> String{
        switch orderType {
        case 0: return "예매율순"
        case 1: return "큐레이션순"
        case 2: return "개봉일순"
        default: return ""
        }
    }
    
    func networkFailAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension UITableViewCell {
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
}

extension UICollectionViewCell {
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
}
