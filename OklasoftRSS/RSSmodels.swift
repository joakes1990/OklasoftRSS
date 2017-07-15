//
//  RSSsupport.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/8/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
import OklasoftNetworking

public struct Feed {
    let title: String
    let url: URL
    let lastUpdated: Date
    let mimeType: mimeTypes
    let stories: [Story]
    
    func requestUpdatedStories() {
        var callbackNotification: Notification.Name
        switch mimeType {
        case .rss, .rssXML:
            callbackNotification = .finishedReceavingRSSStory
            break
        case .atom, .atomXML:
            callbackNotification = .finishedReceavingAtomStory
            break
        case .json:
            callbackNotification = .finishedReceavingJSONStory
            break
        }
      URLSession.shared.getReturnedDataFrom(url: url, returning: callbackNotification)
    }
}

public struct Story {
    let title: String
    let url: URL
    let textContent: String?
    let mediaContent: [URL]
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
    case json = "application/json"
}
