//
//  ViewController.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 08/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var movies: [Movie]?
    var posters: [UIImage]?
    let movieController = MovieController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        getMoviesFromServer(0)
        setNavigationBarItem()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveOrderType), name: .observeOrderType, object: nil)
    }
    
    fileprivate func registerTableViewCell(){
        let nibName = UINib(nibName: "TableListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TableListCell")
    }
    
    fileprivate func getMoviesFromServer(_ orderType: Int) {
        movieController.getMoviesFromServer(orderType: orderType) { (movies, posters) in
            self.movies = movies
            self.posters = posters
            DispatchQueue.main.async {
                let title = self.getTitleByOrderType(orderType)
                self.setTitle(title)
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func setTitle(_ title: String){
        self.navigationItem.title = title
    }
    
    fileprivate func getTitleByOrderType(_ orderType: Int) -> String{
        switch orderType {
        case 0: return "예매율순"
        case 1: return "큐레이션순"
        case 2: return "개봉일순"
        default: return ""
        }
    }
    
    fileprivate func setNavigationBarItem() {
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(setActionSheet))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func setActionSheet(){
        presentActionSheet("정렬방식", "영화를 어떤 순서로 보여드릴까요?") { (orderType) in
            NotificationCenter.default.post(name: .observeOrderType, object: nil, userInfo: ["orderType": orderType])
        }
    }
    
    @objc func receiveOrderType(_ notification: Notification){
        if let orderType = notification.userInfo?["orderType"] as? Int {
            getMoviesFromServer(orderType)
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
        let poster = posters![indexPath.row]
        cell.titleLabel.text = safe(movie.title)
        cell.ratingLabel.text = "\(safe(movie.userRating))"
        cell.rankLabel.text = "\(safe(movie.reservationGrade))"
        cell.salesRatingLabel.text = "\(safe(movie.reservationRate))"
        cell.releaseDateLabel.text = safe(movie.date)
        cell.posterImageView.image = poster
        
        return cell
    }
}

