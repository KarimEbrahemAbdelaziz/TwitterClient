//
//  DBManager.swift
//  TwitterClient
//
//  Created by Graphic on 3/26/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation
import RealmSwift

protocol LoginDatabaseManager {
    func saveToDatabase(object: Object)
    func resetDatabase()
}

protocol UserDatabaseManager {
    func saveFollowersToDatabase(followers: [Follower])
    func getFollowersFromDatabase() -> Results<Follower>
}

class DBManager: LoginDatabaseManager, UserDatabaseManager {
    
    private var database: Realm
    static let sharedInstance = DBManager()
    
    private init() {
        database = try! Realm(configuration: RealmConfiguration.main.configuration)
    }
    
    func getAllFromDatabase<T: Object>(ofType: T.Type) -> Results<T> {
        let results: Results<T> = database.objects(ofType)
        return results
    }
    
    func getObjectFromDatabase<T: Object>(ofType: T.Type, withKey key: String) -> T {
        let result: T = database.object(ofType: ofType, forPrimaryKey: key)!
        return result
    }
    
    func saveToDatabase(object: Object) {
        try! database.write {
            database.add(object, update: true)
        }
    }
    
    func resetDatabase() {
        try! database.write {
            database.deleteAll()
        }
        
    }
    
    func deleteFromDatabase(object: Object) {
        try! database.write {
            database.delete(object)
        }
    }
    
    func saveFollowersToDatabase(followers: [Follower]) {
        for follower in followers {
            saveToDatabase(object: follower)
        }
    }
    
    func getFollowersFromDatabase() -> Results<Follower> {
        let followers = getAllFromDatabase(ofType: Follower.self)
        return followers
    }
    
}
