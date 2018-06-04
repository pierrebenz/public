//
//  NewsFeedModel.swift
//  NewsFeed
//
//  Created by Pierre Benz on 1/8/18.
//  Copyright © 2018 Pierre Benz. All rights reserved.
//

import Foundation

struct NewsFeedModel : Codable {
    var status: String
    var code: String?
    var message: String?
    var totalResults: Int?
    var articles: [NewsModel]?
    
    init() {
        status = ""
        totalResults = 0
        code = ""
        message = ""
        articles = [NewsModel]()
    }
}
