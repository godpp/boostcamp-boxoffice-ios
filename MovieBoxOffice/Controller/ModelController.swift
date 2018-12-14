//
//  ModelController.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 10/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let observeOrderType = Notification.Name("observeOrderType")
}

class ModelController {
    let APIManger = APIManager()
    let response = CallbackResponse()
    
    func getMoviesFromServer(orderType: Int, completion: @escaping (_ moviesData: [(info: Movie, poster:  UIImage)]?, _ code: String) -> ()){
        APIManger.getMovies(orderType) { (movies, code) in
            let result = self.response.result(code)
            switch result{
            case .success:
                self.downloadImageFromServer(movies, completion: { (posters) in
                    guard let movies = movies, let posters = posters else { return }
                    let moviesData = zip(movies, posters).map {($0, $1)}
                    completion(moviesData, code)
                })
            case .failure:
                completion(nil, code)
            }
        }
    }
    
    func getMovieInfoFromServer(id: String, completion: @escaping (_ movieInfo: MovieInfo?, _ poster: UIImage?, _ code: String) -> ()){
        APIManger.getMovieDetail(id) { (movieInfo, code) in
            let result = self.response.result(code)
            switch result{
            case .success:
                if let imageURL = movieInfo?.image {
                    if let image = self.downloadImage(url: imageURL) {
                        completion(movieInfo, image, code)
                    }
                } else {
                    completion(movieInfo, nil, code)
                }
            case .failure:
                completion(movieInfo, nil, code)
            }
        }
    }
    
    func getCommentsFromServer(movieID: String, completion: @escaping (_ comments: [Comment]?) -> ()){
        APIManger.getComments(movieID) { (comments, error) in
            completion(comments)
        }
    }
}

extension ModelController {
    
    fileprivate func downloadImageFromServer(_ movies: [Movie]?, completion: @escaping (_ posters: [UIImage]?) -> ()){
        var imageArray: [UIImage] = []
        DispatchQueue.global().async {
            if let movies = movies{
                for index in movies{
                    if let poster = self.downloadImage(url: index.thumb!){
                        imageArray.append(poster)
                    }
                }
                completion(imageArray)
            }
        }
    }
    
    fileprivate func downloadImage(url: String) -> UIImage?{
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)
            }
        }
        return UIImage()
    }
}
