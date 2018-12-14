//
//  StatueCodeResponse.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 09/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation

enum ResponseResult{
    case success
    case failure
}

struct StatueCodeResponse {
    func result(_ response: HTTPURLResponse) -> ResponseResult{
        switch response.statusCode {
        case 200: return .success
        default:  return .failure
        }
    }
}
