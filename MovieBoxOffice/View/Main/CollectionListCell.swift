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
    @IBOutlet weak var gradeView: GradeView!
    
    var movie: (info: Movie, poster: UIImage)? {
        didSet{
            setDataAtCell(movie?.info, movie?.poster)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setPosterImageView()
        setGradeView()
    }

    fileprivate func setPosterImageView() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 141/98).isActive = true
    }
    
    fileprivate func setGradeView() {
        gradeView.layer.masksToBounds = true
        gradeView.layer.cornerRadius = gradeView.frame.size.width / 2
    }
    
    fileprivate func setDataAtCell(_ info: Movie?, _ poster: UIImage?){
        posterImageView.image = poster
        titleLabel.text = info?.title
        ratingLabel.text = "\(safe(info?.userRating))"
        rankLabel.text = "\(safe(info?.reservationGrade))"
        salesRatingLabel.text = "\(safe(info?.reservationRate))"
        releaseDateLabel.text = safe(info?.date)
        gradeView.textLabel.text = gradeView.getTextFromGrade(safe(info?.grade))
        gradeView.backgroundColor = gradeView.getColorFromGrade(safe(info?.grade))
    }
}
