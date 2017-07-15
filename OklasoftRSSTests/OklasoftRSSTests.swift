//
//  OklasoftRSSTests.swift
//  OklasoftRSSTests
//
//  Created by Justin Oakes on 7/1/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import XCTest
@testable import OklasoftRSS

 class OklasoftRSSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
  
    func testUpdateStories() {
        // Work in progress. At the moment the function dosen't do anything
        let testFeed: Feed = Feed(title: "Test Feed",
                                  url: URL(string:"https://test.com")!,
                                  lastUpdated: Date(),
                                  mimeType: .atomXML,
                                  stories: [])
        self.measure {
            testFeed.updateStories()
        }
    }
}

