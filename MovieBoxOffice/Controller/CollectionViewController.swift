//
//  CollectionViewController.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 10/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UIViewController, DataLoading, ImageDownloading {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var loadingView: LoadingView = {
        let view = LoadingView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        return view
    }()
    
    var state: ViewState = .loading {
        didSet{
            switch state {
            case .loading:
                update(view)
            case .loaded:
                update(view)
                collectionView.reloadData()
            case .refreshed:
                update(view)
                collectionView.reloadData()
            case .error:
                update(view)
            }
        }
    }
    
    private var movies: [Movie]?
    private var posters: [UIImage]?
    private let APIManger = APIManager()
    private let response = CallbackResponse()
    private var orderType: Int = 0{
        didSet{
            getMoviesFromServer(orderType)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveOrderType), name: .observeOrderType, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        registerCollectionViewCell()
        getMoviesFromServer(orderType)
        setNavigationBarItem()
    }
    
    fileprivate func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    fileprivate func registerCollectionViewCell(){
        let nibName = UINib(nibName: "CollectionListCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "CollectionListCell")
    }
    
    fileprivate func getMoviesFromServer(_ orderType: Int) {
        setTitle(getTitleByOrderType(orderType))
        state = .loading
        APIManger.getMovies(orderType) { (movies, code) in
            let result = self.response.result(code)
            switch result{
            case .success:
                DispatchQueue.main.async {
                    self.movies = movies
                    self.collectionView.reloadData()
                }
                DispatchQueue.global(qos: .background).async {
                    self.posters = self.downloadImages(movies)
                    DispatchQueue.main.async {
                        self.state = .loaded
                    }
                }
            case .failure:
                self.state = .error(code: code)
            }
        }
    }
    
    fileprivate func downloadImages(_ movies: [Movie]?) -> [UIImage]{
        var imageArray: [UIImage] = []
        guard let movies = movies else {
            self.state = .error(code: "No Movies Data")
            return imageArray
        }
        for movie in movies{
            if let image = self.downloadImage(url: self.safe(movie.thumb)){
                imageArray.append(image)
            }
        }
        return imageArray
    }
    
    fileprivate func setNavigationBarItem() {
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(setActionSheet))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc fileprivate func setActionSheet(){
        presentActionSheet("정렬방식", "영화를 어떤 순서로 보여드릴까요?") { (orderType) in
            NotificationCenter.default.post(name: .observeOrderType, object: nil, userInfo: ["orderType": orderType])
        }
    }
    
    @objc fileprivate func receiveOrderType(_ notification: Notification){
        if let orderType = notification.userInfo?["orderType"] as? Int {
            self.orderType = orderType
        }
    }
    
    @objc fileprivate func refreshData(_ sender: Any){
        APIManger.getMovies(orderType) { (movies, code) in
            let result = self.response.result(code)
            switch result{
            case .success:
                DispatchQueue.main.async {
                    self.movies = movies
                    self.collectionView.reloadData()
                }
                DispatchQueue.global(qos: .background).async {
                    self.posters = self.downloadImages(movies)
                    DispatchQueue.main.async {
                        self.state = .refreshed
                    }
                }
            case .failure:
                self.state = .error(code: code)
            }
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    fileprivate var sectionInset: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    fileprivate var itemSpacing: CGFloat {
        return 10
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if UIDevice.current.orientation.isLandscape {
            let itemWidth = (UIScreen.main.bounds.size.width - sectionInset.left - sectionInset.right - itemSpacing) / 4
            let itemHeight = itemWidth * 2
            return CGSize(width: itemWidth, height: itemHeight)
        } else {
            let itemWidth = (UIScreen.main.bounds.size.width - sectionInset.left - sectionInset.right - itemSpacing) / 2
            let itemHeight = itemWidth * 2
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = movies?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return setCollectionListCell(collectionView, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = movies?[indexPath.row].id, let title = movies?[indexPath.row].title else { return }
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.id = id
        detailVC.movieTitle = title
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    fileprivate func setCollectionListCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionListCell", for: indexPath) as! CollectionListCell
        let movie = movies![indexPath.row]
        if let poster = posters?[indexPath.row]{
            cell.posterImageView.image = poster
        }
        cell.titleLabel.text = safe(movie.title)
        cell.ratingLabel.text = "(\(safe(movie.userRating)))"
        cell.rankLabel.text = "\(safe(movie.reservationGrade))"
        cell.salesRatingLabel.text = "\(safe(movie.reservationRate))"
        cell.releaseDateLabel.text = safe(movie.date)
        cell.gradeView.textLabel.text = cell.gradeView.getTextFromGrade(safe(movie.grade))
        cell.gradeView.backgroundColor = cell.gradeView.getColorFromGrade(safe(movie.grade))
        return cell
    }
}
