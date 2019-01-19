//
//  ViewController.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 08/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, DataLoading, ImageDownloading {

    @IBOutlet weak var tableView: UITableView!
    
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
                tableView.reloadData()
            case .refreshed:
                update(view)
                tableView.reloadData()
            case .error:
                update(view)
            }
        }
    }
    
    private var movies: [Movie]?
    private var posters: [UIImage]?
    private let cellId: String = "TableListCell"
    private let response = CallbackResponse()
    private let APIManger = APIManager()
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
        setTableView()
        registerTableViewCell()
        getMoviesFromServer(orderType)
        setNavigationBarItem()
    }
    
    fileprivate func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    fileprivate func registerTableViewCell(){
        let nibName = UINib(nibName: "TableListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func getMoviesFromServer(_ orderType: Int) {
        setTitle(getTitleByOrderType(orderType))
        state = .loading
        APIManger.getMovies(orderType) { [weak self](movies, code) in
            guard let self = self else {return}
            let result = self.response.result(code)
            switch result{
            case .success:
                DispatchQueue.main.async {
                    self.movies = movies
                    self.tableView.reloadData()
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
                self.movies = movies
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = movies?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setTableListCell(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = movies?[indexPath.row].id, let title = movies?[indexPath.row].title else { return }
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.id = id
        detailVC.movieTitle = title
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    fileprivate func setTableListCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableListCell
        let movie = movies![indexPath.row]
        if let poster = posters?[indexPath.row]{
            cell.posterImageView.image = poster
        }
        cell.titleLabel.text = safe(movie.title)
        cell.ratingLabel.text = "\(safe(movie.userRating))"
        cell.rankLabel.text = "\(safe(movie.reservationGrade))"
        cell.salesRatingLabel.text = "\(safe(movie.reservationRate))"
        cell.releaseDateLabel.text = safe(movie.date)
        cell.gradeView.textLabel.text = cell.gradeView.getTextFromGrade(safe(movie.grade))
        cell.gradeView.backgroundColor = cell.gradeView.getColorFromGrade(safe(movie.grade))
        return cell
    }
}

