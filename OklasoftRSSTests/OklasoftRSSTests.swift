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

 class OklasoftRSSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
// RSS Testing
    func testRSSIdent() {
        let rssURL: URL = URL(string:"http://feeds.macrumors.com/MacRumors-All")!
        URLSession.shared.getReturnedDataFrom(url: rssURL, with: URLSession.identifyFeedsCompletion)
        let expectation: XCTNSNotificationExpectation = XCTNSNotificationExpectation(name: .finishedReceavingFeed)
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testUpdateFavIcon() {
        let testFeed: Feed = Feed(title: "Test",
                                  url: URL(string: "http://feeds.macrumors.com/MacRumors-All")!,
                                  canonicalURL: URL(string: "http://macrumors.com/")!,
                                  lastUpdated: nil,
                                  mimeType: .simpleRSS,
                                  favIcon: nil)
        XCTAssertNil(testFeed.favIcon)
        let updateExpect: XCTNSNotificationExpectation = XCTNSNotificationExpectation(name: .foundFavIcon)
        self.wait(for: [updateExpect], timeout: 60)
        
        XCTAssertNotNil(testFeed.favIcon)
    }
}

