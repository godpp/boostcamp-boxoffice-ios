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
    
    var dataLoadingState: DataLoadingState = .loading {
        didSet{
            switch dataLoadingState {
            case .loading:
                actionAfterStateChanged(view)
            case .loaded:
                actionAfterStateChanged(view)
                tableView.reloadData()
            case .refreshed:
                actionAfterStateChanged(view)
                tableView.reloadData()
            case .error:
                actionAfterStateChanged(view)
            }
        }
    }
    
    private var movies: [Movie]?
    private var posters: [UIImage]?
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
        tableView.register(nibName, forCellReuseIdentifier: "TableListCell")
    }
    
    fileprivate func getMoviesFromServer(_ orderType: Int) {
        setTitle(getTitleByOrderType(orderType))
        dataLoadingState = .loading
        APIManger.getMovies(orderType) { (movies, code) in
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
                        self.dataLoadingState = .loaded
                    }
                }
            case .failure:
                self.dataLoadingState = .error(code: code)
            }
        }
    }
    
    fileprivate func downloadImages(_ movies: [Movie]?) -> [UIImage]{
        var imageArray: [UIImage] = []
        guard let movies = movies else {
            self.dataLoadingState = .error(code: "No Movies Data")
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
                        self.dataLoadingState = .refreshed
                    }
                }
            case .failure:
                self.dataLoadingState = .error(code: code)
            }
        }
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
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            preconditionFailure("DetailViewController Error")
        }
        detailVC.id = id
        detailVC.movieTitle = title
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    fileprivate func setTableListCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableListCell", for: indexPath) as? TableListCell else {
            preconditionFailure("TableListCell Error")
        }
        let movie = movies![indexPath.row]
        guard let poster = posters?[indexPath.row] else { return cell }
        cell.configure(movieData: movie, moviePoster: poster)
        return cell
    }
}

