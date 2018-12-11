//
//  CollectionListCell.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 08/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class CollectionListCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var salesRatingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 141/98).isActive = true

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
