//
//  CollectionViewController.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 10/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewContrller: UICollectionViewController {
    
    let APIManger = APIManager()
    var movies: [Movie]?
    var posters: [UIImage]?
    let movieController = MovieController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionViewCell()
        getMoviesFromServer(0)
        setNavigationBarItem()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveOrderType), name: .observeOrderType, object: nil)
    }
    
    fileprivate func registerCollectionViewCell(){
        let nibName = UINib(nibName: "CollectionListCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "CollectionListCell")
    }
    
    fileprivate func getMoviesFromServer(_ orderType: Int) {
        movieController.getMoviesFromServer(orderType: orderType) { (movies, posters) in
            self.movies = movies
            self.posters = posters
            DispatchQueue.main.async {
                let title = self.getTitleByOrderType(orderType)
                self.setTitle(title)
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func setTitle(_ title: String){
        self.title = title
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

extension CollectionViewContrller: UICollectionViewDelegateFlowLayout {
    
    fileprivate var sectionInset: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    fileprivate var itemSpacing: CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (UIScreen.main.bounds.size.width - sectionInset.left - sectionInset.right - itemSpacing)/2
        let itemHeight = itemWidth * 2
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = movies?.count{
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionListCell", for: indexPath) as! CollectionListCell
        let movie = movies![indexPath.row]
        let poster = posters![indexPath.row]
        cell.titleLabel.text = safe(movie.title)
        cell.ratingLabel.text = "(\(safe(movie.userRating))) "
        cell.rankLabel.text = "\(safe(movie.reservationGrade))"
        cell.salesRatingLabel.text = "\(safe(movie.reservationRate))"
        cell.releaseDateLabel.text = safe(movie.date)
        cell.posterImageView.image = poster
        return cell
    }
    
}
