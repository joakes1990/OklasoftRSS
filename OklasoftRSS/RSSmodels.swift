//
//  RSSsupport.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/8/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
import OklasoftNetworking

public class Feed {
    let title: String
    let url: URL
    var lastUpdated: Date
    let mimeType: mimeTypes
    var stories: [Story]
    
    init(title: String, url: URL, lastUpdated: Date, mimeType: mimeTypes, stories: [Story]) {
        self.title = title
        self.url = url
        self.lastUpdated = lastUpdated
        self.mimeType = mimeType
        self.stories = stories
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receaveUpdatedStories(anotification:)),
                                               name: .finishedFindingStories,
                                               object: nil)
        requestUpdatedStories()
    }
    
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
        URLSession.shared.getReturnedDataFrom(url: url, with: <#T##networkCompletion?##networkCompletion?##(Data?, URLResponse?, Error?) -> Void#>)
    }
    
    @objc func receaveUpdatedStories(anotification: Notification) {
        guard let userInfo: [AnyHashable:Any] = anotification.userInfo,
            let requester: URL = userInfo.keys.first as? URL,
            let newStories: [Story] = (userInfo[requester] as? [Story]) ?? nil
            else {
                return
        }
        if requester == url {
            // Functional AF
            stories.insert(contentsOf: newStories.filter({$0.pubdate > lastUpdated}).sorted(by: {$0.pubdate > $1.pubdate}),
                           at: 0)
            lastUpdated = Date()
        }
    }
}

public struct Story {
    let title: String
    let url: URL
    let textContent: String?
    let mediaContent: [URL]
    let pubdate: Date
    let read: Bool
    let feedURL: URL
}

public enum mimeTypes: String {
    public typealias RawValue = String
    
    case atom = "application/atom"
    case atomXML = "application/atom+xml"
    case rss = "application/rss"
    case rssXML = "application/rss+xml"
    case json = "application/json"
}
