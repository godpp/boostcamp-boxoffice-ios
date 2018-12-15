//
//  GradeView.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 12/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class GradeView: UIView {

    @IBOutlet weak var textLabel: UILabel!
    
    private let xibName = "GradeView"
    
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

    func getColorFromGrade(_ grade: Int) -> UIColor {
        switch grade {
        case 0:  return UIColor(red: 95/255, green: 159/255, blue: 78/255, alpha: 1.0)
        case 12: return UIColor(red: 78/255, green: 165/255, blue: 237/255, alpha: 1.0)
        case 15: return UIColor(red: 240/255, green: 154/255, blue: 64/255, alpha: 1.0)
        case 19: return UIColor(red: 215/255, green: 74/255, blue: 71/255, alpha: 1.0)
        default: return UIColor()
        }
    }
    
    func getTextFromGrade(_ grade: Int) -> String {
        switch grade {
        case 0:  return "전체"
        case 12: return "12"
        case 15: return "15"
        case 19: return "19"
        default: return ""
        }
    }
    
}
