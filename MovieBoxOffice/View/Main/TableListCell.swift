//
//  TableListCell.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 08/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class TableListCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var salesRatingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var gradeView: GradeView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGradeView()
    }

    fileprivate func setGradeView() {
        gradeView.layer.masksToBounds = true
        gradeView.layer.cornerRadius = gradeView.frame.size.width / 2
    }
    
    func configure(movieData: Movie, moviePoster: UIImage) {
        posterImageView.image = moviePoster
        titleLabel.text = safe(movieData.title)
        ratingLabel.text = "\(safe(movieData.userRating))"
        rankLabel.text = "\(safe(movieData.reservationGrade))"
        salesRatingLabel.text = "\(safe(movieData.reservationRate))"
        releaseDateLabel.text = safe(movieData.date)
        gradeView.textLabel.text = gradeView.getTextFromGrade(safe(movieData.grade))
        gradeView.backgroundColor = gradeView.getColorFromGrade(safe(movieData.grade))
    }
}

extension TableListCell {
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
}
