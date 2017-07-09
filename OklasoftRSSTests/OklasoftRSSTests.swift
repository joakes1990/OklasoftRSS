//
//  OklasoftRSSTests.swift
//  OklasoftRSSTests
//
//  Created by Justin Oakes on 7/1/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import XCTest
@testable import OklasoftRSS
import OklasoftNetworking


class OklasoftRSSTests: XCTestCase, ReaderObserver {
    
    var atom: Feed? = nil
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIdentifyingAtomFeed() {
        let testAtomURL: URL = URL(string: "https://daringfireball.net/feeds/main")!
        let isAtomExpectation: XCTKVOExpectation = XCTKVOExpectation(keyPath: "atom",
                                                                     object: self)
        URLSession.shared.getReturnedDataFrom(url: testAtomURL, with: URLSession.identifyFeedsCompletion)
        self.wait(for: [isAtomExpectation], timeout: 10)
    }
    
    @objc func receavedNewFeed(aNotification: Notification) {
        guard let userInfo: [AnyHashable : Any] = aNotification.userInfo,
            let feed: Feed = userInfo[feedInfoKey] as? Feed else {
                let error: errorInfo = errorInfo(error: couldnotFindUserInfo)
                NotificationCenter.default.post(name: .feedIdentificationError,
                                                object: nil,
                                                userInfo: error.toDict())
                return
        }
        switch feed.mimeType {
        case .atom, .atomXML:
            atom = feed
            break
        default:
            break
        }
    }
//
//
//    func testIdentifyRSSFeed() {
//        let testRSSURL: URL = URL(string: "http://feeds.macrumors.com/MacRumors-All")!
//        URLSession.shared.getReturnedDataFrom(url: testRSSURL, with: URLSession.identifyFeedsCompletion)
//        let expectation: XCTNSNotificationExpectation = XCTNSNotificationExpectation(name: .finishedReceavingFeed)
//        self.wait(for: [expectation], timeout: 10)
//    }
//
//    func testIdentifyJsonFeed() {
//        let testJsonFeedURL: URL = URL(string: "https://jsonfeed.org/feed.json")!
//        URLSession.shared.getReturnedDataFrom(url: testJsonFeedURL, with: URLSession.identifyFeedsCompletion)
//        let expectation: XCTNSNotificationExpectation = XCTNSNotificationExpectation(name: .finishedReceavingFeed)
//        self.wait(for: [expectation], timeout: 10)
//    }
}

