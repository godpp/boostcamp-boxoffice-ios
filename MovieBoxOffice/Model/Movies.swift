//
//  MovieListData.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 08/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation

struct Movies: Codable {
    let orderType: Int?
    let movies: [Movie]?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case orderType = "order_type"
        case movies
        case message
    }
}

struct Movie: Codable {
    
    let grade: Int?
    let thumb: String?
    let reservationGrade: Int?
    let title: String?
    let reservationRate: Double?
    let userRating: Double?
    let date: String?
    let id: String?
    
    private enum CodingKeys: String, CodingKey {
        case grade
        case thumb
        case reservationGrade = "reservation_grade"
        case title
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
        case date
        case id
    }
}
