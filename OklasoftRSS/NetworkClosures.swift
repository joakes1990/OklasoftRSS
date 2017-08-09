//
//  NetworkClosures.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/6/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
import WebKit
#if os(OSX)
    import OklasoftNetworking
#elseif os(iOS)
    import OklasoftNetworking_iOS_
#endif


public extension URLSession {
    
    static let identifyFeedsCompletion: networkCompletion = {(data, responce, error) in
        if let foundError:Error = error {
            NotificationCenter.default.post(name: .networkingErrorNotification,
                                            object: nil,
                                            userInfo:errorInfo(error: foundError).toDict())
            return
        }
        guard let headers: URLResponse = responce,
            let validData: Data = data,
            let typeString: String = headers.mimeType,
            let mimeType: mimeTypes = mimeTypes(rawValue:typeString),
            let url: URL = headers.url,
            let title: String = url.host
            else {
                let error: Error = unrecognizableDataError
                NotificationCenter.default.post(name: .feedIdentificationError,
                                                object: nil,
                                                userInfo: [errorInfoKey:error])
                return
        }
        
        func parentURLForRSS() -> URL? {
            guard let pageXML: String = String(data: validData, encoding: .utf8),
                let linkRange: Range = pageXML.range(of: "(?<=<link>)(.+)(?=</link>)",
                                                     options: .regularExpression,
                                                     range: pageXML.range(of: pageXML),
                                                     locale: nil)
                else {
                    return nil
            }
            
            let linkString: String = pageXML.substring(with: linkRange)
            return URL(string: linkString)
        }
        
        var canonicalURL: URL? = nil
        switch mimeType {
        case .rss, .rssXML, .simpleRSS:
            canonicalURL = parentURLForRSS()
            break
        default:
            break
        }
        let newFeed: Feed = Feed(title: title,
                                 url: url,
                                 canonicalURL: canonicalURL,
                                 lastUpdated: nil,
                                 mimeType: mimeType,
                                 favIcon: nil)
        NotificationCenter.default.post(name: .finishedReceavingFeed,
                                        object: nil,
                                        userInfo: [feedInfoKey:newFeed])
        
    }
    
    static let identifyStoriesCompletion: networkCompletion = {(data, responce, error) in
        if let foundError:Error = error {
            NotificationCenter.default.post(name: .networkingErrorNotification,
                                            object: nil,
                                            userInfo:errorInfo(error: foundError).toDict())
            return
        }
        guard let headers: URLResponse = responce,
            let validData: Data = data,
            let mimeType: mimeTypes = mimeTypes(rawValue:(headers.mimeType ?? "")),
            let url: URL = headers.url
            else {
                return
        }
        switch mimeType {
        case .rss, .rssXML:
            let parser: XMLParser = XMLParser(data: validData)
            parser.parseRSSFeed(fromParent: url)
            break
        case .atom, .atomXML:
            let parser: XMLParser = XMLParser(data: validData)
            parser.parseAtomFeed(fromParent: url)
            break
        //TODO: add other types
        default:
            break
        }
    }
    
    static let findFeedsCompletion: networkCompletion = {(data, responce, error) in
        if let foundError:Error = error {
            NotificationCenter.default.post(name: .networkingErrorNotification,
                                            object: nil,
                                            userInfo:errorInfo(error: foundError).toDict())
            return
        }
        guard let headers: URLResponse = responce,
            let validData: Data = data,
            let mimeType: mimeTypes = mimeTypes(rawValue:(headers.mimeType ?? "")),
            let url: URL = headers.url
            else {
                return
        }
        switch mimeType {
        case .html:
            guard let htmlString: String = String(data: validData, encoding: .utf8) else {
                NotificationCenter.default.post(name: .errorConvertingHTML,
                                                object: nil,
                                                userInfo: [errorInfoKey:unrecognizableDataError])
                return
            }
            do {
            let document: XMLDocument = try XMLDocument(xmlString: htmlString, options: .documentTidyHTML)
            let parser: XMLParser = XMLParser(data: document.xmlData)
            parser.parseHTMLforFeeds(fromSite: url)
            } catch {
                NotificationCenter.default.post(name: .errorConvertingHTML,
                                                object: nil,
                                                userInfo: [errorInfoKey:unrecognizableDataError])
                return
            }
            break
        default:
            break
        }
    }
}
