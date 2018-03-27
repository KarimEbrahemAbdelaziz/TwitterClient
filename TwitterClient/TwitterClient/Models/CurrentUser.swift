//
//  CurrentUser.swift
//  TwitterClient
//
//  Created by Graphic on 3/26/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class CurrentUser: Object {
    
    @objc dynamic var userId = ""
    @objc dynamic var userDescription = ""
    @objc dynamic var userName = ""
    @objc dynamic var userFriendsCount = 0
    @objc dynamic var userFollowersCount = 0
    var followers = List<Follower>()
    
    convenience required init(userId: String, userDescription: String, userName: String, userFriendsCount: Int, userFollowersCount: Int) {
        self.init()
        self.userId = userId
        self.userDescription = userDescription
        self.userName = userName
        self.userFriendsCount = userFriendsCount
        self.userFollowersCount = userFollowersCount
    }
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
}

// MARK:- Static Function That make Code Easier :)
extension CurrentUser {
    
    static func getCurrentUserFromDatabase() -> CurrentUser {
        let currentUser = DBManager.sharedInstance.getAllFromDatabase(ofType: self).first!
        return currentUser
    }
    
}



