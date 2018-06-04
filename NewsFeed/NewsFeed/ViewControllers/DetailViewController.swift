//
//  DetailViewController.swift
//  NewsFeed
//
//  Created by Pierre Benz on 1/8/18.
//  Copyright © 2018 Pierre Benz. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var btnURL: UIButton!
    
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    var newsModel: NewsModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateUI()
    }
    
    func populateUI() {
        self.navigationItem.largeTitleDisplayMode = .never
        if let title = newsModel.title {
            lblTitle.text = title
        } else {
            lblTitle.text = "Title unavailable"
        }
        
        if let author = newsModel.author {
            lblAuthor.text = "Author: " + author
        } else {
            lblAuthor.text = "Author unavailable"
        }
        
        if let details = newsModel.description {
            lblDetails.text = details
        } else {
            lblDetails.text = "Description unavailable"
        }
        
        if let date = newsModel.publishedAt {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            
            if let formattedDate = dateFormatter.date(from: date) {
                
                dateFormatter.dateFormat = "MM-dd-YYYY"
                lblDate.text = "Date: " + dateFormatter.string(from: formattedDate)
            } else {
                lblDate.text = date
            }
        } else {
            lblDate.text = "Date unavailable"
        }
        
        if newsModel.url == nil {
            btnURL.isHidden = true
        }
        
    }
    
    @IBAction func btnURLtapped(_ sender: Any) {
        if let url = URL(string: newsModel.url!) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
}
