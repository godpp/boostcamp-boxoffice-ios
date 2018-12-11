//
//  MovieInfo.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 11/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation

struct MovieInfo: Codable {
    
    let audience: Int?
    let actor: String?
    let duration: Int?
    let director: String?
    let synopsis: String?
    let genre: String?
    let grade: Int?
    let image: String?
    let reservationGrade: Int?
    let title: String?
    let reservationRate: Double?
    let userRating: Double?
    let date: String?
    let id: String?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case audience
        case actor
        case duration
        case director
        case synopsis
        case genre
        case grade
        case image
        case reservationGrade = "reservation_grade"
        case title
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
        case date
        case id
        case message
    }
}
