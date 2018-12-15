//
//  RatingView.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 12/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class RatingView: UIView {

    @IBOutlet var starImageViews: [UIImageView]!
    
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
        self.addSubview(view)
    }
    
    func setStarImage(_ rating: Double){
        let roundRating = Int(round(rating))
        let halfRating = Int(roundRating / 2)
        
        for i in 0..<halfRating{
            starImageViews[i].image = UIImage(named: "star")
        }
        if isOddRating(roundRating) {
            starImageViews[halfRating].image = UIImage(named: "halfstar")
            setGrayStarImage(halfRating+1)
        } else{
            setGrayStarImage(halfRating)
        }
    }
    
    fileprivate func setGrayStarImage(_ halfRating: Int) {
        for i in halfRating..<5{
            starImageViews[i].image = UIImage(named: "graystar")
        }
    }
    
    fileprivate func isOddRating(_ num: Int) -> Bool{
        if num % 2 != 0 { return true  }
        else            { return false }
    }
}
