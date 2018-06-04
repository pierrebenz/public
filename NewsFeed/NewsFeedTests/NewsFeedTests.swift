//
//  NewsFeedTests.swift
//  NewsFeedTests
//
//  Created by Pierre Benz on 1/8/18.
//  Copyright © 2018 Pierre Benz. All rights reserved.
//

import XCTest
import OHHTTPStubs.Swift
@testable import NewsFeed

class NewsFeedTests: XCTestCase {
    
    var expect : XCTestExpectation?
    
    var request: URLRequest?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testSuccesfulNewsFeedModelRetreival200() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Arrange
        //
        // Setup network stubs
        
        let urlStr = "newsapi.org"
        
        expect = expectation(description: "Setting expectation for remote \"faking\" to return")
        
        stub(condition: isHost(urlStr)) { _ in
            let stubPath = OHPathForFile("successResponse.json", type(of: self))
            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
        }
        
        let newsManager = NewsFeedManager()
        newsManager.delegate = self
        newsManager.getArticles()
        
        waitForExpectations(timeout: 500) { error in
            print("error waiting for tests to return, check OHTTPStubs setup above")
            return
        }
        
        var newsFeedModel = newsManager.newsFeedModel
        
        XCTAssert(newsFeedModel.status == "ok")
        XCTAssert(newsFeedModel.totalResults == 20)
        var article = newsFeedModel.articles![0]
        XCTAssert(article.title == "After Florida Gets Offshore Drilling Exemption, Other States Ask For The Same")
        XCTAssert(article.description == "The Trump administration has proposed radically expanding offshore oil drilling, but Florida's waters are \"off the table.\" Leaders in California, New York, South Carolina and elsewhere noticed.")
        XCTAssert(article.author == "")
        XCTAssert(article.url == "https://www.npr.org/sections/thetwo-way/2018/01/10/577064733/after-florida-gets-offshore-drilling-exemption-other-states-ask-for-the-same")
        
        article = newsFeedModel.articles![19]
        XCTAssert(article.title == "Huge stakes in Texas firm's hunt for missing Malaysian Airlines Flight 370")
        XCTAssert(article.description == "Malaysian government will pay Ocean Infinity up to $70 million if it can find wreckage or black boxes of MH370")
        XCTAssert(article.author == "CBS/AP")
        XCTAssert(article.url == "https://www.cbsnews.com/news/malaysia-airlines-flight-370-search-70-million-wreckage-ocean-infinity/")
        
        OHHTTPStubs.removeAllStubs() // as per https://github.com/AliSoftware/OHHTTPStubs/wiki/Remove-stubs-after-each-test
        
    }
    
    func testUnsuccessfulNewsFeedModelRetreival401() {
        let urlStr = "newsapi.org"
        
        expect = expectation(description: "Setting expectation for remote \"faking\" to return")
        
        stub(condition: isHost(urlStr)) { _ in
            let stubPath = OHPathForFile("unsuccessfulResponse401.json", type(of: self))
            return fixture(filePath: stubPath!, status: 401, headers: ["Content-Type":"application/json"])
        }
        
        let newsManager = NewsFeedManager()
        newsManager.delegate = self
        newsManager.getArticles()
        
        waitForExpectations(timeout: 500) { error in
            print("error waiting for tests to return, check OHTTPStubs setup above")
            return
        }
        
        let newsModel = newsManager.newsFeedModel
        XCTAssert(newsModel.status == "error")
        XCTAssert(newsModel.code == "apiKeyMissing")
        XCTAssert(newsModel.message == "Your API key is missing. Append this to the URL with the apiKey param, or use the x-api-key HTTP header.")
        
        OHHTTPStubs.removeAllStubs() // as per https://github.com/AliSoftware/OHHTTPStubs/wiki/Remove-stubs-after-each-test
        
    }
    
    func testUnsuccessfulNewsFeedModelRetreival400() {
        let urlStr = "newsapi.org"
        
        expect = expectation(description: "Setting expectation for remote \"faking\" to return")
        
        stub(condition: isHost(urlStr)) { _ in
            let stubPath = OHPathForFile("unsuccessfulResponse400.json", type(of: self))
            return fixture(filePath: stubPath!, status: 400, headers: ["Content-Type":"application/json"])
        }
        
        let newsManager = NewsFeedManager()
        newsManager.delegate = self
        newsManager.getArticles()
        
        waitForExpectations(timeout: 500) { error in
            print("error waiting for tests to return, check OHTTPStubs setup above")
            return
        }
        
        let newsModel = newsManager.newsFeedModel
        XCTAssert(newsModel.status == "error")
        XCTAssert(newsModel.code == "parametersMissing")
        XCTAssert(newsModel.message == "Required parameters are missing, the scope of your search is too broad. Please set any of the following required parameters and try again: q, sources, domains.")
        
        OHHTTPStubs.removeAllStubs() // as per https://github.com/AliSoftware/OHHTTPStubs/wiki/Remove-stubs-after-each-test
    }
}

extension NewsFeedTests: NewsFeedManagerDelegate {
    func newsFeedManagerDelegate(_ newsFeedManager: NewsFeedManager, didUpdateWith newsFeedModel: NewsFeedModel, withResponse statusCode: Int) {
        expect?.fulfill()
    }
    func newsFeedManagerDelegate(_ newsFeedManager: NewsFeedManager, didNotCompleteRequest statusCode: Int) {
        expect?.fulfill()
    }
    
    func newsFeedManagerDelegate(_ newsFeedManager: NewsFeedManager, failedWithReason code: ResponseCode) {
        expect?.fulfill()
    }
}

