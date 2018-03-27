//
//  Follower.swift
//  TwitterClient
//
//  Created by Graphic on 3/27/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Follower: Object {
    
    @objc dynamic var followerId = ""
    @objc dynamic var followerProfileImage = ""
    @objc dynamic var followerBackgroundImage = ""
    @objc dynamic var followerName = ""
    @objc dynamic var followerHandle = ""
    @objc dynamic var followerBio = ""
    var tweets = List<Tweet>()
    
    convenience required init(followerId: String, followerProfileImage: String, followerBackgroundImage: String?, followerName: String, followerHandle: String, followerBio: String) {
        self.init()
        self.followerId = followerId
        self.followerProfileImage = followerProfileImage
        if followerBackgroundImage != nil {
            self.followerBackgroundImage = followerBackgroundImage!
        }
        self.followerName = followerName
        self.followerHandle = followerHandle
        self.followerBio = followerBio
    }
    
    override static func primaryKey() -> String? {
        return "followerId"
    }
    
}
