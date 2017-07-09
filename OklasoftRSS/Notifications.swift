//
//  Notifications.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/2/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation

public let feedInfoKey = "feed"

public extension Notification.Name {
    static let finishedReceavingFeed = Notification.Name("finishedReceavingFeed")
    static let feedIdentificationError = Notification.Name("notificationError")
}
