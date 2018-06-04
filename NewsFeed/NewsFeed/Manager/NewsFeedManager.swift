//
//  NewsFeedManager.swift
//  NewsFeed
//
//  Created by Pierre Benz on 1/8/18.
//  Copyright © 2018 Pierre Benz. All rights reserved.
//
import Foundation

enum ResponseCode {
    case noResponse
    case noData
}
protocol NewsFeedManagerDelegate {
    
    func newsFeedManagerDelegate(_ newsFeedManager: NewsFeedManager, didUpdateWith newsFeedModel: NewsFeedModel, withResponse statusCode: Int)
    func newsFeedManagerDelegate(_ newsFeedManager: NewsFeedManager, didNotCompleteRequest statusCode: Int)
    func newsFeedManagerDelegate(_ newsFeedManager: NewsFeedManager, failedWithReason code: ResponseCode)
}

class NewsFeedManager: NSObject {
    
    let urlStr = "https://newsapi.org/v2/top-headlines?country=us&language=en&apiKey=335b46683de64c6aa1ebf5dc9f5d98c7"
    
    var newsFeedModel = NewsFeedModel()
    
    var delegate: NewsFeedManagerDelegate?
    
    override init() {
        super.init()
    }
    
    func getArticles() {
        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 30.0
            sessionConfig.timeoutIntervalForResource = 60.0
            let session = URLSession(configuration: sessionConfig)
            session.dataTask(with: request) {data, response, err in
                
                guard let response = response as? HTTPURLResponse else {
                    self.delegate?.newsFeedManagerDelegate(self, failedWithReason: .noResponse)
                    return
                }

                guard let data = data else {
                    self.delegate?.newsFeedManagerDelegate(self, failedWithReason: .noData)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.newsFeedModel = try decoder.decode(NewsFeedModel.self, from: data)
                    self.delegate?.newsFeedManagerDelegate(self, didUpdateWith: self.newsFeedModel, withResponse: response.statusCode)
                } catch let err {
                    self.delegate?.newsFeedManagerDelegate(self, didNotCompleteRequest: response.statusCode)
                    print(err)
                }
                
            }.resume()
            
        } else {
            print("Could not request url: \(self.urlStr)")
        }
    }
}
