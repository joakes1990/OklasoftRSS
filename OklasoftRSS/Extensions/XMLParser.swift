//
//  OklasoftXML.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/21/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation

public extension XMLParser {
    
    public func parseRSSFeed(fromParent url: URL) {
        let rssDelegate: RSSDelegate = RSSDelegate(with: url)
        delegate = rssDelegate
        parse()
    }
    
    public func parseAtomFeed(fromParent url: URL) {
        let atomDelegate: AtomDelegate = AtomDelegate(with: url)
        delegate = atomDelegate
        parse()
    }
    
    public func parseHTMLforFavIcon(fromSite url: URL) {
        
    }
}
