//
//  Notifications.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/2/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation

public let feedInfoKey = "feed"
public let storyInfoKey = "story"
public extension Notification.Name {
    static let finishedReceavingFeed = Notification.Name("finishedReceavingFeed")
    static let finishedReceavingRSSStory = Notification.Name("finishedReceavingRSSData")
    static let finishedReceavingAtomStory = Notification.Name("finishedReceavingRSSAtomData")
    static let finishedReceavingJSONStory = Notification.Name("finishedReceavingRSSJSONFeedData")
    static let feedIdentificationError = Notification.Name("notificationError")
    static let finishedFindingStories = Notification.Name("finishedFindingStories")
    static let errorFindingStories = Notification.Name("errorFindingStories")
}
