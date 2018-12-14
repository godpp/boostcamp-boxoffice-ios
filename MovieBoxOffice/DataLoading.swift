//
//  DataLoading.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 14/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation
import UIKit

enum ViewState {
    case loading
    case loaded
    case error(code: String)
}

protocol DataLoading {
    
    var loadingView: LoadingView { get }
    var state: ViewState { get set }
    
    func update(_ view: UIView)
}

extension DataLoading where Self: UIViewController {
    func update(_ view : UIView) {
        switch state {
        case .loading:
            loadingView.center = view.center
            loadingView.indicator.startAnimating()
            view.addSubview(loadingView)
        case .loaded:
            loadingView.indicator.stopAnimating()
            loadingView.removeFromSuperview()
        case .error(let code):
            DispatchQueue.main.async {
                let errorAlert = UIAlertController(title: "오류", message: code, preferredStyle: .alert)
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
}
