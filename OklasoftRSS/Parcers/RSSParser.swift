//
//  RSSParser.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/14/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
import OklasoftNetworking

class RSSParser: NSObject, XMLParserDelegate {
    
    var stories: [Story] = []
    var element: parseValues?
    
    let feedURL: URL
    var url: URL?
    var title: String?
    var textContent: String?
    var mediaContent: [URL]?
    var pubDate: Date?
    
    init(with url: URL) {
        self.feedURL = url
        super.init()
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if let rssProperty: parseValues = parseValues(rawValue: elementName) {
            element = rssProperty
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let hasElement: parseValues = element else {
            return
        }
        switch hasElement {
        case .title:
            title = title == nil ? string : "\(String(describing: title))\((string))"
            break
        case .link:
            guard let itemURL = URL(string: string) else {
                return
            }
            url = itemURL
            break
        case .description:
            textContent = textContent == nil ? string : "\(String(describing: textContent))\(string)"
            break
        case .pubDate:
            pubDate = rfc822DateFromString(string: string)
            break
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let rssProperty: parseValues = parseValues(rawValue: elementName) {
            switch rssProperty {
            case .item:
                pushStory()
                url = nil
                title = nil
                textContent = nil
                mediaContent = nil
                pubDate = nil
                break
            default:
                break
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        NotificationCenter.default.post(name: .finishedFindingStories,
                                        object: nil,
                                        userInfo: [feedURL:stories])
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        NotificationCenter.default.post(name: .errorFindingStories,
                                        object: nil,
                                        userInfo: [errorInfoKey:parseError])
    }
    
    func rfc822DateFromString(string: String) -> Date? {
        let RFC822Date: String = "ddd, dd MMM yyyy HH:mm:ssZZZZZ"
        let dateFormater: DateFormatter = DateFormatter()
        dateFormater.dateFormat = RFC822Date
        
        return dateFormater.date(from: string)
    }
    
    func pushStory() {
        guard let storyURL: URL = url,
            let storyTitle: String = title,
            let storyText: String = textContent,
            let storyMedia: [URL] = mediaContent,
            let storyDate: Date = pubDate
            else {
                return
        }
        let newStory: Story = Story(title: storyTitle,
                                    url: storyURL,
                                    textContent: storyText,
                                    mediaContent: storyMedia,
                                    pubdate: storyDate,
                                    read: false,
                                    feedURL: feedURL)
        stories.append(newStory)
    }
    
    
    enum parseValues: String {
        typealias rawValue = String
        
        case item = "item"
        case title = "title"
        case link = "link"
        case description = "description"
        case pubDate = "pubDate"
        
    }
}
