//
//  ViewController.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 08/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let APIManger = APIManager()
    var movies: [Movie]?
    var posters: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        registerTableViewCell()
        getMoviesFromServer(orderType: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func registerTableViewCell(){
        let nibName = UINib(nibName: "TableListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TableListCell")
    }
    
    fileprivate func getMoviesFromServer(orderType: Int){
        APIManger.getMovies(orderType) { (movies, error) in
            self.movies = movies
            self.downloadImageFromServer()
        }
    }
    fileprivate func downloadImageFromServer(){
        DispatchQueue.global(qos: .background).async {
            if let movies = self.movies{
                for index in movies{
                    if let poster = self.downloadImage(url: self.safe(index.thumb)){
                        self.posters.append(poster)
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension TableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = movies?.count{
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableListCell", for: indexPath) as! TableListCell
        let movie = movies![indexPath.row]
        let poster = posters[indexPath.row]
        cell.titleLabel.text = safe(movie.title)
        cell.ratingLabel.text = "\(safe(movie.userRating))"
        cell.rankLabel.text = "\(safe(movie.reservationGrade))"
        cell.salesRatingLabel.text = "\(safe(movie.reservationRate))"
        cell.releaseDateLabel.text = safe(movie.date)
        cell.posterImageView.image = poster
        
        return cell
    }
}

