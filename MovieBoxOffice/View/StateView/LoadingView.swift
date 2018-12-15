//
//  LoadingView.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 14/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private let xibName = "LoadingView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initXIB()
    }
    
    private func initXIB(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        view.center = self.center
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        self.addSubview(view)
    }
}
