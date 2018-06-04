//
//  NewsModel.swift
//  NewsFeed
//
//  Created by Pierre Benz on 1/8/18.
//  Copyright © 2018 Pierre Benz. All rights reserved.
//

import Foundation

struct NewsModel :Codable {
    var author: String?
    var title: String?
    var description: String?
    var url : String?
    var publishedAt: String?
 
    init() {
        
    }
}
