//
//  APIManager.swift
//  TwitterClient
//
//  Created by Graphic on 3/24/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation
import TwitterKit
import SwiftyJSON

class APIManager {
    
    private var twtrTwitter: TWTRTwitter?
    static let sharedInstance = APIManager()
    
    private init() {
        self.twtrTwitter = TWTRTwitter.sharedInstance()
        twtrTwitter?.start(withConsumerKey: Constants.Keys.consumerKey, consumerSecret: Constants.Keys.consumerSecret)
    }
    
    func login(completion:  @escaping (_: Bool?, _: Error?)->Void) {
        twtrTwitter?.logIn(completion: { (session, error) in
            if (session != nil) {
                completion(true, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    func getExistingUserSessions() -> Int {
        return (twtrTwitter?.sessionStore.existingUserSessions().count)!
    }
    
}
