//
//  APIManager.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 09/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation

struct APIManager {
    
    let apiCenter = APICenter<BoxOfficeAPI>()
    let apiResponse = APIResponse()
    
    func getMovies(_ orderType: Int, completion: @escaping (_ movie: [Movie]?, _ error: String?) -> ()){
        apiCenter.request(.movies(order_type: orderType)) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                let result = self.apiResponse.result(response)
                switch result {
                case .success:
                    guard let responseData = data else { return }
                    do{
                        let decodeJSON = try JSONDecoder().decode(Movies.self, from: responseData)
                        if let message = decodeJSON.message{
                            completion(nil, message)
                        } else{
                            completion(decodeJSON.movies, nil)
                        }
                    } catch{
                        completion(nil, "Decoding Error")
                    }
                case .failure:
                    completion(nil, "Networking Fail")
                }
            }
        }
    }
    
    func getMovieDetail(_ id: String, completion: @escaping (_ movieInfo: MovieInfo?, _ error: String?) -> ()){
        apiCenter.request(.movie(id: id)) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                let result = self.apiResponse.result(response)
                switch result {
                case .success:
                    guard let responseData = data else { return }
                    do{
                        let decodeJSON = try JSONDecoder().decode(MovieInfo.self, from: responseData)
                        if let message = decodeJSON.message{
                            completion(nil, message)
                        } else{
                            completion(decodeJSON, nil)
                        }
                    } catch{
                        completion(nil, "Decoding Error")
                    }
                case .failure:
                    completion(nil, "Networking Fail")
                }
            }
        }
    }
    
    func getComments(_ movieID: String, completion: @escaping (_ comments: [Comment]?, _ error: String?) -> ()){
        apiCenter.request(.comments(movie_id: movieID)) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                let result = self.apiResponse.result(response)
                switch result {
                case .success:
                    guard let responseData = data else { return }
                    do{
                        let decodeJSON = try JSONDecoder().decode(Comments.self, from: responseData)
                        if let message = decodeJSON.message{
                            completion(nil, message)
                        } else{
                            completion(decodeJSON.comments, nil)
                        }
                    } catch{
                        completion(nil, "Decoding Error")
                    }
                case .failure:
                    completion(nil, "Networking Fail")
                }
            }
        }
    }
}
