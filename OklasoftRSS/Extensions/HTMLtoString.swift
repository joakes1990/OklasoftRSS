//
//  HTMLtoString.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/21/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation

public extension String {
    
    class func getPlainTextFromHTML(html: String) -> String {
        let regExPattern: String = "/(<.*?.>)/g"
        let regEx: NSRegularExpression = try NSRegularExpression(pattern: regExPattern, options: nil)
        regEx.replaceMatches(in: html,
                             options: nil,
                             range: String.range(html),
                             withTemplate: "")
        return html
    }
}
