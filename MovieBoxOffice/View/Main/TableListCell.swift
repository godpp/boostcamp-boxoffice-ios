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
    
    func configure(_ poster: UIImage, andMovie data: Movie) {
        posterImageView.image = poster
        titleLabel.text = safe(data.title)
        ratingLabel.text = "\(safe(data.userRating))"
        rankLabel.text = "\(safe(data.reservationGrade))"
        salesRatingLabel.text = "\(safe(data.reservationRate))"
        releaseDateLabel.text = safe(data.date)
        gradeView.textLabel.text = gradeView.getTextFromGrade(safe(data.grade))
        gradeView.backgroundColor = gradeView.getColorFromGrade(safe(data.grade))
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
