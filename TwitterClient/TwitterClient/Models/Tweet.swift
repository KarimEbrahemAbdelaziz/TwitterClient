//
//  Tweet.swift
//  TwitterClient
//
//  Created by Graphic on 3/27/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Tweet: Object {
    
    @objc dynamic var tweetId = ""
    @objc dynamic var tweetText = ""
    @objc dynamic var tweetCreatedAt = ""
    
    convenience required init(tweetId: String, tweetText: String, tweetCreatedAt: String) {
        self.init()
        self.tweetId = tweetId
        self.tweetText = tweetText
        self.tweetCreatedAt = tweetCreatedAt
    }
    
    override static func primaryKey() -> String? {
        return "tweetId"
    }
    
}
