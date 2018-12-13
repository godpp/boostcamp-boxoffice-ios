//
//  MovieCommentsCell.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 11/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class MovieCommentsCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUserImageView()
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
    }
    
    fileprivate func setUserImageView(){
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.image = UIImage(named: "user")
    }
}
