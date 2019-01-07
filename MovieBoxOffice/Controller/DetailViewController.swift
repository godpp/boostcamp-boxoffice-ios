//
//  DetailViewController.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 11/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, DataLoading, ImageDownloading {

    @IBOutlet weak var movieDetailTableView: UITableView!
    
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
                movieDetailTableView.reloadData()
            case .error:
                update(view)
            case .refreshed:
                break
            }
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var id: String?
    var movieTitle: String?
    private var movieInfo: MovieInfo?
    private var poster: UIImage?
    private var comments: [Comment]?
    private let APIManger = APIManager()
    private let response = CallbackResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = safe(movieTitle)
        setTableView()
        registerTableViewCell()
        getDataFromServer(safe(id))
    }
    
    fileprivate func setTableView(){
        movieDetailTableView.delegate = self
        movieDetailTableView.dataSource = self
        movieDetailTableView.tableHeaderView = UIView(frame: CGRect.zero)
        movieDetailTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    fileprivate func registerTableViewCell(){
        let movieInfoNib = UINib(nibName: "MovieInfoCell", bundle: nil)
        movieDetailTableView.register(movieInfoNib, forCellReuseIdentifier: "MovieInfoCell")
        let movieSynopsisNib = UINib(nibName: "MovieSynopsisCell", bundle: nil)
        movieDetailTableView.register(movieSynopsisNib, forCellReuseIdentifier: "MovieSynopsisCell")
        let directorInfoNib = UINib(nibName: "DirectorInfoCell", bundle: nil)
        movieDetailTableView.register(directorInfoNib, forCellReuseIdentifier: "DirectorInfoCell")
        let movieCommentsNib = UINib(nibName: "MovieCommentsCell", bundle: nil)
        movieDetailTableView.register(movieCommentsNib, forCellReuseIdentifier: "MovieCommentsCell")
    }
    
    fileprivate func getDataFromServer(_ id: String){
        let group = DispatchGroup()
        var check: Bool = true
        state = .loading

        group.enter()
        getInfoDataFromServer(id, completion: { (isSuccess) in
            check = isSuccess && check
            DispatchQueue.global(qos: .background).async {
                self.downloadImage(self.movieInfo)
            }
            group.leave()
        })
        group.enter()
        getCommentsDataFromServer(id, completion: { (isSuccess) in
            check = isSuccess && check
            group.leave()
        })
        
        group.notify(queue: .main) {
            switch check{
            case true:
                self.movieDetailTableView.reloadData()
            case false:
                self.state = .error(code: "Data Loading Fail")
            }
        }
    }
    
    fileprivate func downloadImage(_ movieInfo: MovieInfo?){
        if let imageURL = movieInfo?.image {
            if let image = self.downloadImage(url: imageURL) {
                  self.poster = image
                DispatchQueue.main.async {
                    self.state = .loaded
                }
            }
        }
    }
    
    fileprivate func getInfoDataFromServer(_ id: String, completion: @escaping (_ isSuccess: Bool) -> ()){
        APIManger.getMovieDetail(id) { (movieInfo, code) in
            let result = self.response.result(code)
            switch result{
            case .success:
                self.movieInfo = movieInfo
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    fileprivate func getCommentsDataFromServer(_ id: String, completion: @escaping (_ isSuccess: Bool) -> ()){
        APIManger.getComments(id) { (comments, code) in
            let result = self.response.result(code)
            switch result{
            case .success:
                self.comments = comments
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}

extension DetailViewController: PosterTapDelegate{
    
    func posterTapDelegate() {
        let posterVC = self.storyboard?.instantiateViewController(withIdentifier: "PosterViewController") as! PosterViewController
        posterVC.poster = poster
        present(posterVC, animated: true, completion: nil)
    }
}
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            if let count = comments?.count{
                return count
            }
            return 0
        default:
            if movieInfo != nil{
                return 1
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "줄거리"
        case 2: return "감독/출연"
        case 3: return "한줄평"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return setMovieInfoCell(indexPath)
        case 1:
            return setSynopsisCell(indexPath)
        case 2:
            return setDirectorCell(indexPath)
        case 3:
            return setCommentsCell(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    fileprivate func setMovieInfoCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = movieDetailTableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as! MovieInfoCell
        cell.posterImageView.image = poster
        cell.titleLabel.text = safe(movieInfo?.title)
        cell.releaseDateLabel.text = safe(movieInfo?.date)
        cell.genresLabel.text = safe(movieInfo?.genre)
        cell.durationLabel.text = "\(safe(movieInfo?.duration))"
        cell.rankLabel.text = "\(safe(movieInfo?.reservationGrade))"
        cell.salesLabel.text = "\(safe(movieInfo?.reservationRate))"
        cell.ratingLabel.text = "\(safe(movieInfo?.userRating))"
        cell.audienceLabel.text = numberFormatter.string(for: safe(movieInfo?.audience))
        cell.gradeView.textLabel.text = cell.gradeView.getTextFromGrade(safe(movieInfo?.grade))
        cell.gradeView.backgroundColor = cell.gradeView.getColorFromGrade(safe(movieInfo?.grade))
        cell.ratingView.setStarImage(safe(movieInfo?.userRating))
        cell.delegate = self
        return cell
    }
    
    fileprivate func setSynopsisCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = movieDetailTableView.dequeueReusableCell(withIdentifier: "MovieSynopsisCell", for: indexPath) as! MovieSynopsisCell
        cell.synopsisLabel.text = safe(movieInfo?.synopsis)
        return cell
    }
    
    fileprivate func setDirectorCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = movieDetailTableView.dequeueReusableCell(withIdentifier: "DirectorInfoCell", for: indexPath) as! DirectorInfoCell
        cell.directorLabel.text = safe(movieInfo?.director)
        cell.actorLabel.text = safe(movieInfo?.actor)
        return cell
    }
    
    fileprivate func setCommentsCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = movieDetailTableView.dequeueReusableCell(withIdentifier: "MovieCommentsCell", for: indexPath) as! MovieCommentsCell
        let comment = comments![indexPath.row]
        let date = Date(timeIntervalSince1970: safe(comment.timeStamp))
        cell.writerLabel.text = safe(comment.writer)
        cell.timeStampLabel.text = dateFormatter.string(from: date)
        cell.commentLabel.text = safe(comment.contents)
        cell.ratingView.setStarImage(safe(comment.rating))
        return cell
    }
}
