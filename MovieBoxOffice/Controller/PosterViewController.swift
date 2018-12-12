//
//  PosterViewController.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 12/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var poster: UIImage?
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setZoomScale()
        setPoster(poster)
    }
    
    fileprivate func setPoster(_ poster: UIImage?){
        posterImageView.image = poster
    }
    
    fileprivate func setZoomScale(){
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return posterImageView
    }

}
