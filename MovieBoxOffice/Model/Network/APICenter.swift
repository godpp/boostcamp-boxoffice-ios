//
//  APICenter.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 09/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation

protocol APIService {
    var baseURL: URL   { get }
    var subURL: String { get }
}

enum BoxOfficeAPI {
    case movies(order_type: Int)
    case movie(id: String)
    case comments(movie_id: String)
}

extension BoxOfficeAPI: APIService {
    
    var baseURL: URL {
        guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/") else { fatalError("Invalid URL") }
        return url
    }
    
    var subURL: String {
        switch self {
        case .movies(let order_type):
            return "movies?order_type=\(order_type)"
        case .movie(let id):
            return "movie?id=\(id)"
        case .comments(let movie_id):
            return "comments?movie_id=\(movie_id)"
        }
    }
}

class APICenter<Service: APIService>{
    
    let statusCode = StatueCodeResponse()
    
    func request(_ server: Service, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ code: String) -> ()){
        guard let url = URL(string: server.baseURL.absoluteString + server.subURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return } 
            guard error == nil else {
                completion(nil,nil,"Internet Connection Fail")
                return
            }
            guard let data = data else {
                completion(nil, nil, "Data Receive Fail")
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = self.statusCode.result(response)
                switch result{
                case .success:
                    completion(data, response, "success")
                case .failure:
                    completion(nil, nil, "404 Error")
                }
            }
        }
        task.resume()
    }
}
