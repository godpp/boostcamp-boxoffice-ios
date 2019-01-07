//
//  Comments.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 11/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation

struct Comments: Codable {
    
    let movieID: String?
    let comments: [Comment]?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case comments, message
        case movieID = "movie_id"
    }
}

struct Comment: Codable {
    
    let rating: Double?
    let timeStamp: Double?
    let writer: String?
    let movieID: String?
    let contents: String?
    
    private enum CodingKeys: String, CodingKey {
        case rating, writer, contents
        case timeStamp = "timestamp"
        case movieID = "movie_id"
    }
}
