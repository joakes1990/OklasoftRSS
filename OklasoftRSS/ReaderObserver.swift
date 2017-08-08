//
//  ReaderObserver.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/1/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
#if os(OSX)
    import OklasoftNetworking
#elseif os(iOS)
    import OklasoftNetworking_iOS_
#endif


public class FeedController {
    
    static let shared: FeedController = FeedController()
    var feeds: [Feed] = []
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receavedNewFeed(aNotification:)),
                                               name: .finishedReceavingFeed,
                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(receavedNewRSSStory(aNotification:)),
//                                               name: .finishedReceavingRSSStory,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(receavedNewAtomStory(aNotification:)),
//                                               name: .finishedReceavingAtomStory,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(receavedNewJSONStory(aNotification:)),
//                                               name: .finishedReceavingJSONStory,
//                                               object: nil)
    }
    
    @objc func receavedNewFeed(aNotification: Notification) {
        guard let userInfo: [AnyHashable:Any] = aNotification.userInfo,
            let newFeed: Feed = userInfo[feedInfoKey] as? Feed ?? nil
        else {
            return
        }
        feeds.append(newFeed)
    }
    
    @objc func receavedNewRSSStory(aNotification: Notification) {
        
    }
    
    @objc func receavedNewAtomStory(aNotification: Notification) {
        
    }
    
    @objc func receavedNewJSONStory(aNotification: Notification) {
        
    }
    
}
