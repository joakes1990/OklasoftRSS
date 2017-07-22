//
//  HTMLtoString.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/21/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation

public extension String {
    
    static func getPlainTextFromHTML(html: String) -> String {
        let regExPattern: String = "/(<.*?.>)/g"
        let plainText: String = html.replacingOccurrences(of: regExPattern,
                                  with: "",
                                  options: .regularExpression,
                                  range: html.range(of:html))
        return plainText
    }
}
