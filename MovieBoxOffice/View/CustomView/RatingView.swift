//
//  RatingView.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 12/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class RatingView: UIView {

    @IBOutlet weak var rateImageView: UIImageView!
    
    private let xibName = "RatingView"
    
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
        view.center = center
        self.addSubview(view)
    }

}
