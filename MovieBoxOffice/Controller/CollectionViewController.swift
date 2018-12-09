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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionViewCell()
    }
    
    fileprivate func registerCollectionViewCell(){
        let nibName = UINib(nibName: "CollectionListCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "CollectionListCell")
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
        let itemWidth = (UIScreen.main.bounds.size.width / 2) - sectionInset.left - sectionInset.right
        return CGSize(width: itemWidth, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionListCell", for: indexPath) as! CollectionListCell
        cell.posterImageView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        return cell
    }
    
}
