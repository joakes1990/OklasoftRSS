//
//  RSSParser.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/14/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
import OklasoftNetworking
import WSLHTMLEntities

class RSSDelegate: NSObject, XMLParserDelegate {
    
    var stories: [Story] = []
    fileprivate var element: parseValues?
    
    let feedURL: URL
    var url: URL?
    var title: String?
    var htmlContent: String?
    var audioContent: [URL]?
    var pubDate: Date?
    
    init(with url: URL) {
        self.feedURL = url
        super.init()
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if let rssProperty: parseValues = parseValues(rawValue: elementName) {
            if rssProperty == .enclosure, let _: mimeTypes = mimeTypes(rawValue: attributeDict["type"] ?? ""),
            let audioLocation: String = attributeDict["url"] {
                guard let audioURL: URL = URL(string: audioLocation) else {
                    return
                }
                audioContent == nil ? audioContent = [audioURL] : audioContent?.append(audioURL)
            }
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
            htmlContent = htmlContent == nil ? string : "\(String(describing: htmlContent))\(string)"
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
                htmlContent = nil
                audioContent = nil
                pubDate = nil
                break
            default:
                element = nil
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
            let storyHTML: String = htmlContent,
            let storyDate: Date = pubDate
            else {
                return
        }
        let newStory: baseStory = baseStory(title: storyTitle,
                                            url: storyURL,
                                            textContent: <#T##String#>,
                                            htmlContent: WSLHTMLEntities.convertHTMLtoString(storyHTML),
                                            pubdate: storyDate,
                                            read: false,
                                            feedURL: feedURL,
                                            imageContent: nil,
                                            author: nil)
        if let storyaudio: [URL] = audioContent {
            let podCast: PodCast = PodCast(story: newStory, audio: storyaudio)
            stories.append(podCast)
        } else {
            stories.append(newStory)
        }
    }
    
    
    fileprivate enum parseValues: String {
        typealias rawValue = String
        
        case item = "item"
        case title = "title"
        case link = "link"
        case description = "description"
        case pubDate = "pubDate"
        case enclosure = "enclosure"
        
    }
}
