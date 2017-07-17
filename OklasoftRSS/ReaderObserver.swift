//
//  ReaderObserver.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/1/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
import OklasoftNetworking

public class StoryConstructor {
    
    static let shared: StoryConstructor = StoryConstructor()
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receavedNewFeed(aNotification:)),
                                               name: .finishedReceavingFeed,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receavedNewRSSStory(aNotification:)),
                                               name: .finishedReceavingRSSStory,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receavedNewAtomStory(aNotification:)),
                                               name: .finishedReceavingAtomStory,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receavedNewJSONStory(aNotification:)),
                                               name: .finishedReceavingJSONStory,
                                               object: nil)
    }
    
    @objc func receavedNewFeed(aNotification: Notification) {
        guard let userInfo: [AnyHashable:Any] = aNotification.userInfo else {
            return
        }
        
    }
    
    @objc func receavedNewRSSStory(aNotification: Notification) {
        
    }
    
    @objc func receavedNewAtomStory(aNotification: Notification) {
        
    }
    
    @objc func receavedNewJSONStory(aNotification: Notification) {
        
    }
    
}
