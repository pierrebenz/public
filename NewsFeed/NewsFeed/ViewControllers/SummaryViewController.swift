//
//  ViewController.swift
//  NewsFeed
//
//  Created by Pierre Benz on 1/8/18.
//  Copyright © 2018 Pierre Benz. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    var newsFeedManager = NewsFeedManager()
    
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var errorViewContainer: UIVisualEffectView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var dataSource = [NewsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        newsFeedManager.delegate = self
        newsFeedManager.getArticles()
    }
}

extension SummaryViewController {
    func setupUI() {
        self.navigationItem.largeTitleDisplayMode = .always 
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "SummaryTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SummaryTableViewCell")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let newsModel = sender as! NewsModel
            let destination = segue.destination as! DetailViewController
            destination.newsModel = newsModel
        }
    }
    
    func displayError(message: String) {
        errorViewContainer.isHidden = false
        errorView.isHidden = false
        errorLabel.isHidden = false        
        errorLabel.text = message
        
        let _ = Timer.scheduledTimer(timeInterval: 5,
                                     target: self,
                                     selector: #selector(self.hideError),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    @objc func hideError() {
        DispatchQueue.main.async {
            self.errorViewContainer.isHidden = true
            self.errorView.isHidden = true
            self.errorLabel.isHidden = true
        }
    }
}

extension SummaryViewController: NewsFeedManagerDelegate {
    func newsFeedManagerDelegate(_ newsFeedManager: NewsFeedManager, didUpdateWith newsFeedModel: NewsFeedModel, withResponse statusCode: Int) {
        DispatchQueue.main.async {
            self.dataSource = newsFeedModel.articles!
            self.tableView.reloadData()
        }
    }
    
    func newsFeedManagerDelegate(_ newsFeedManager: NewsFeedManager, failedWithReason code: ResponseCode) {
        DispatchQueue.main.async {
            if code == .noData {
                self.displayError(message: "An error occured: No data found")
            } else if code == .noResponse {
                self.displayError(message: "An error occured: Could not get a response")
            }
        }
    }
    
    func newsFeedManagerDelegate(_ newsFeedManager: NewsFeedManager, didNotCompleteRequest statusCode: Int) {
        DispatchQueue.main.async {
            if let message = newsFeedManager.newsFeedModel.message {
                self.displayError(message: message)
            } else {
                self.displayError(message: "An error occured but with unknown reason")
            }
        }
    }
}

extension SummaryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell", for: indexPath) as? SummaryTableViewCell {            
            
            if let data = dataSource[indexPath.row].title {
                cell.lblTitle.text = data
            } else {
                cell.lblTitle.text = "No title available"
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension SummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsModel = self.dataSource[indexPath.row]
        self.performSegue(withIdentifier: "showDetails", sender: newsModel)
    }
}



