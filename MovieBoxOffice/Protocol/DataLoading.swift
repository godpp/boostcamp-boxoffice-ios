//
//  DataLoading.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 14/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

enum ViewState {
    case loading
    case loaded
    case refreshed
    case error(code: String)
}

protocol DataLoading {
    
    var loadingView: LoadingView { get }
    var refreshControl: UIRefreshControl { get }
    var state: ViewState { get set }
    
    func update(_ view: UIView)
}

extension DataLoading where Self: UIViewController {
    
    var refreshControl: UIRefreshControl {
        get{ return UIRefreshControl() }
    }
    
    func update(_ view : UIView) {
        switch state {
        case .loading:
            loadingView.center = view.center
            loadingView.indicator.startAnimating()
            view.addSubview(loadingView)
        case .loaded:
            loadingView.indicator.stopAnimating()
            loadingView.removeFromSuperview()
        case .refreshed:
            refreshControl.endRefreshing()
        case .error(let code):
            DispatchQueue.main.async {
                let errorAlert = UIAlertController(title: "오류", message: code, preferredStyle: .alert)
                self.present(errorAlert, animated: true, completion: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
