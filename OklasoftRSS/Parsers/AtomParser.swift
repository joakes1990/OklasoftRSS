//
//  AtomParser.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/16/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
import OklasoftNetworking

class AtomParser: RSSParser {
    
    fileprivate var element: parseValues?
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if let atomProperty: parseValues = parseValues(rawValue: elementName) {
            element = atomProperty
            
            switch atomProperty {
            case .link:
                if let _: String = attributeDict["rel"] == "alternate" {
                    element = .link
                }
                    altLink: String = attributeDict.values[attributeDict.keys["rel"]] {
                    element = altLink == "alternate" ? .link : nil
                    // pseudo code then guard let href come from attrdict and set it to the title property else break
                }
            break
            }
        }
    }
    
    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let atomProperty: parseValues = parseValues(rawValue: elementName) {
            switch atomProperty {
            case .entry:
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
    fileprivate enum 
    fileprivate enum parseValues: String {
        typealias RawValue = String
        
        case entry = "entry" //between tags
        case title = "title" //between tags
        case link = "link" // in atttabutes
        case content = "content" //between tags but need to read the attributes to know what king of data you're dealing with. figure out if i should use content or summery on case by case
        case updated = "updated" //between tags
    }
}
