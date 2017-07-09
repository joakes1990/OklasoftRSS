//
//  ReaderObserver.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/1/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
import OklasoftNetworking

public class ReaderObserver: NSObject {
    
    override init() {
        super.init()
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(receavedNewFeed(aNotification:)),
//                                               name: .networkingSuccessNotification,
//                                               object: nil)
    }
    
//    @objc func receavedNewFeed(aNotification: Notification) {
//        guard let userInfo: [AnyHashable : Any] = aNotification.userInfo else {
//            let error: errorInfo = errorInfo(error: couldnotFindUserInfo)
//            NotificationCenter.default.post(name: .feedIdentificationError,
//                                            object: nil,
//                                            userInfo: error.toDict())
//            return
//        }
//    }
}
