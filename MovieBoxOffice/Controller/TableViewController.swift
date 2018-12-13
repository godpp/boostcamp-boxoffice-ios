//
//  ViewController.swift
//  MovieBoxOffice
//
//  Created by ParkSungJoon on 08/12/2018.
//  Copyright © 2018 Park Sung Joon. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, DataLoading {

    @IBOutlet weak var tableView: UITableView!
    
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
            case .error(let message):
                print(message)
            }
        }
    }
    
    var moviesData: [(info: Movie, poster: UIImage)]?
    let modelController = ModelController()
    let response = CallbackResponse()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        registerTableViewCell()
        getMoviesFromServer(0)
        setNavigationBarItem()
    }
    
    fileprivate func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveOrderType), name: .observeOrderType, object: nil)
    }
    
    fileprivate func registerTableViewCell(){
        let nibName = UINib(nibName: "TableListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TableListCell")
    }
    
    fileprivate func getMoviesFromServer(_ orderType: Int) {
        state = .loading
        modelController.getMoviesFromServer(orderType: orderType) { (moviesData, code)  in
            let result = self.response.result(code!)
            switch result{
            case .success:
                self.moviesData = moviesData
                DispatchQueue.main.async {
                    let title = self.getTitleByOrderType(orderType)
                    self.setTitle(title)
                    self.state = .loaded
                }
            case .failure:
                self.state = .error(message: self.safe(code))
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

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = moviesData?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setTableListCell(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = moviesData?[indexPath.row].info.id, let title = moviesData?[indexPath.row].info.title else { return }
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.id = id
        detailVC.movieTitle = title
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    fileprivate func setTableListCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableListCell", for: indexPath) as! TableListCell
        let movie = moviesData![indexPath.row]
        cell.movie = movie
        return cell
    }
}

