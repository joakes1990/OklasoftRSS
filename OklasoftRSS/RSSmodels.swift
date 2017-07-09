//
//  RSSsupport.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/8/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation

public struct Feed {
    let title: String
    let url: URL
    let lastUpdated: Date
    let mimeType: mimeTypes
    let stories: [Story]
    
    func updateStories() {
        
    }
}

public struct Story {
    let title: String
    let url: URL
    let content: String
    let pubdate: Date
    let read: Bool
    let feed: Feed
}

public enum mimeTypes: String {
    public typealias RawValue = String
    
    case atom = "application/atom"
    case atomXML = "application/atom+xml"
    case rss = "application/rss"
    case rssXML = "application/rss+xml"
    case genaricXML = "text/xml"
    case json = "application/json"
}
