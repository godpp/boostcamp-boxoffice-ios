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
    
    func getMoviesFromServer(orderType: Int, completion: @escaping (_ movies: [Movie]?, _ posters: [UIImage]) -> ()){
        APIManger.getMovies(orderType) { (movies, error) in
            self.downloadImageFromServer(movies, completion: { (posters) in
                completion(movies, posters)
            })
        }
    }
    
    func getMovieInfoFromServer(id: String, completion: @escaping (_ movieInfo: MovieInfo?, _ poster: UIImage) -> ()){
        APIManger.getMovieDetail(id) { (movieInfo, error) in
            if let imageURL = movieInfo?.image {
                if let image = self.downloadImage(url: imageURL) {
                    completion(movieInfo,image)
                }
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
    fileprivate func downloadImageFromServer(_ movies: [Movie]?, completion: @escaping (_ posters: [UIImage]) -> ()){
        var imageArray: [UIImage] = []
        DispatchQueue.global(qos: .background).async {
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
