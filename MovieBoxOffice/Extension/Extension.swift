//
//  Extension.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 09/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

extension UINavigationController
{
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIViewController {
    
    //MARK: Optional Binding
    func safe(_ data: Int?) -> Int {
        guard let unlock = data else { return 0 }
        return unlock
    }
    
    func safe(_ data: Double?) -> Double {
        guard let unlock = data else { return 0.0 }
        return unlock
    }
    
    func safe(_ data: String?) -> String {
        guard let unlock = data else { return "" }
        return unlock
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
}
