//
//  RSSsupport.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/8/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
#if os(OSX)
    import OklasoftNetworking
#elseif os(iOS)
    import OklasoftNetworking_iOS_
#endif


public class Feed {
    let title: String
    let url: URL
    let canonicalURL: URL?
    var favIcon: URL?
    var lastUpdated: Date?
    let mimeType: mimeTypes
    var stories: [Story]
    
    init(title: String, url: URL, canonicalURL: URL?, lastUpdated: Date?, mimeType: mimeTypes, favIcon: URL?) {
        self.title = title
        self.url = url
        self.canonicalURL = canonicalURL
        self.lastUpdated = lastUpdated
        self.mimeType = mimeType
        self.stories = []
        self.favIcon = favIcon
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receaveUpdatedStories(anotification:)),
                                               name: .finishedFindingStories,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receaveUpdatedFavIcon(anotification:)),
                                               name: .foundFavIcon,
                                               object: nil)
        requestUpdatedFavIcon()
        requestUpdatedStories()
    }
    
    func requestUpdatedFavIcon() {
        guard let baseURL: URL = canonicalURL != nil ? canonicalURL : URL(string:"http://\(url.host ?? "")") else {
            return
        }
        unowned let unownedSelf: Feed = self
        URLSession.shared.getReturnedDataFrom(url: baseURL) { (data, responce, error) in
            if let foundError: Error = error {
                //TODO: Log error.
                //no need to report a default image is already provided
                print(foundError)
                return
            }
            guard let validData: Data = data
            else {
                //TODO: Log error.
                //no need to report a default image is already provided
                print(unrecognizableDataError)
                return
            }
            let parser: XMLParser = XMLParser(data: validData)
            parser.parseHTMLforFavIcon(fromSite: unownedSelf.url)
        }
    }
    
    @objc func receaveUpdatedFavIcon(anotification: Notification) {
        guard let userInfo: [AnyHashable:Any] = anotification.userInfo,
            let imageLink: URL = userInfo[url] as? URL else {
                return
        }
        favIcon = imageLink
    }
    
    func requestUpdatedStories() {
        unowned let unownedSelf: Feed = self
        URLSession.shared.getReturnedDataFrom(url: url) { (data, respone, error) in
            if let foundError: Error = error {
                NotificationCenter.default.post(name: .feedIdentificationError,
                                                object: nil,
                                                userInfo: [errorInfoKey:foundError])
                return
            }
            guard let validData: Data = data else {
                return
            }
            let parser: XMLParser = XMLParser(data: validData)
            switch unownedSelf.mimeType {
            case .atom, .atomXML:
                parser.parseAtomFeed(fromParent: unownedSelf.url)
                break
            case .rss, .rssXML, .simpleRSS:
                parser.parseRSSFeed(fromParent: unownedSelf.url)
                break
            default:
                return
            }
        }
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
            stories.insert(contentsOf: newStories.filter({$0.pubdate > lastUpdated ?? Date.init(timeIntervalSinceReferenceDate: 0)}).sorted(by: {$0.pubdate > $1.pubdate}),
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
    public let author: String?
}

public struct PodCast: Story {
    
    public let title: String
    public let url: URL
    public let textContent: String
    public let htmlContent: String
    public let pubdate: Date
    public var read: Bool
    public let feedURL: URL
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
    case simpleRSS = "text/xml"
    case json = "application/json"
    case html = "text/html"
    case m4a = "audio/x-m4a"
    case mpegA = "audio/mpeg"
    case mpeg3 = "audio/mpeg3"
    case xmpeg3 = "audio/x-mpeg-3"
    case aac = "audio/aac"
    case mp4A = "audio/mp4"
    
}
