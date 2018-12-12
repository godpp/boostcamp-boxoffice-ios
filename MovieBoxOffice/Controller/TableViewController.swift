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
    let modelController = ModelController()
    
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
        modelController.getMoviesFromServer(orderType: orderType) { (movies, posters) in
            self.movies = movies
            self.posters = posters
            DispatchQueue.main.async {
                let title = self.getTitleByOrderType(orderType)
                self.setTitle(title)
                self.tableView.reloadData()
            }
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
        cell.gradeView.textLabel.text = cell.gradeView.getTextFromGrade(safe(movie.grade))
        cell.gradeView.backgroundColor = cell.gradeView.getColorFromGrade(safe(movie.grade))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = movies![indexPath.row].id
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.id = id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

