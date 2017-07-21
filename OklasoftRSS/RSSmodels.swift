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
    let favIcon: URL
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
    
    func requestUpdatedFavIcon() {
        
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
        default:
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

public protocol Story {
    
    var title: String {get}
    var url: URL {get}
    var textContent: String {get}
    var htmlContent: String {get}
    var pubdate: Date {get}
    var read: Bool {get set}
    var feedURL: URL {get}
    var imageContent: [URL]? {get}
    var author: String? {get}
}

public struct baseStory: Story {
    public let title: String
    public let url: URL
    public let textContent: String
    public let htmlContent: String
    public let pubdate: Date
    public var read: Bool
    public let feedURL: URL
    public let imageContent: [URL]?
    public let author: String?
    
    func extractTextFromHTML(html: String) {
        
    }
}

public struct PodCast: Story {
    
    public let title: String
    public let url: URL
    public let textContent: String
    public let htmlContent: String
    public let pubdate: Date
    public var read: Bool
    public let feedURL: URL
    public let imageContent: [URL]?
    public let author: String?
    
    let audioContent: [URL]
    
    init(story: Story, audio: [URL]) {
        self.title = story.title
        self.url = story.url
        self.textContent = story.textContent
        self.htmlContent = story.htmlContent
        self.pubdate = story.pubdate
        self.read = story.read
        self.feedURL = story.feedURL
        self.imageContent = story.imageContent
        self.author = story.author
        self.audioContent = audio
    }
}

public enum mimeTypes: String {
    public typealias rawValue = String
    
    case atom = "application/atom"
    case atomXML = "application/atom+xml"
    case rss = "application/rss"
    case rssXML = "application/rss+xml"
    case json = "application/json"
    case html = "text/html"
    case m4a = "audio/x-m4a"
    case mpegA = "audio/mpeg"
    case mpeg3 = "audio/mpeg3"
    case xmpeg3 = "audio/x-mpeg-3"
    case aac = "audio/aac"
    case mp4A = "audio/mp4"
    
}
