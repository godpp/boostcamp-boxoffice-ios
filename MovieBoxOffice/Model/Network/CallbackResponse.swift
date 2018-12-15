//
//  CallbackResponse.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 13/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation

enum CallbackResult{
    case success
    case failure
}

struct CallbackResponse {
    func result(_ code: String?) -> CallbackResult{
        switch code {
        case "success": return .success
        default:        return .failure
        }
    }
}
