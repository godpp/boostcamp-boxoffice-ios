//
//  CollectionViewController.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 10/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UIViewController, DataLoading {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
            case .error(let message):
                print(message)
            }
        }
    }
    
    let APIManger = APIManager()
    var moviesData: [(info: Movie, poster: UIImage)]?
    let modelController = ModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        registerCollectionViewCell()
        getMoviesFromServer(0)
        setNavigationBarItem()
    }
    
    fileprivate func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(receiveOrderType), name: .observeOrderType, object: nil)
    }
    
    fileprivate func registerCollectionViewCell(){
        let nibName = UINib(nibName: "CollectionListCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "CollectionListCell")
    }
    
    fileprivate func getMoviesFromServer(_ orderType: Int) {
        state = .loading
        modelController.getMoviesFromServer(orderType: orderType) { (moviesData, error) in
            self.moviesData = moviesData
            DispatchQueue.main.async {
                let title = self.getTitleByOrderType(orderType)
                self.setTitle(title)
                self.state = .loaded
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

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
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
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = moviesData?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return setCollectionListCell(collectionView, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = moviesData?[indexPath.row].info.id, let title = moviesData?[indexPath.row].info.title else { return }
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.id = id
        detailVC.movieTitle = title
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    fileprivate func setCollectionListCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionListCell", for: indexPath) as! CollectionListCell
        let movie = moviesData![indexPath.row]
        cell.movie = movie
        return cell
    }
}
