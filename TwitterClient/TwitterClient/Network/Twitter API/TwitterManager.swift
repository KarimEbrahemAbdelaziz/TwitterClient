//
//  APIManager.swift
//  TwitterClient
//
//  Created by Graphic on 3/24/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation
import SwiftyJSON
import Accounts
import SwifteriOS

class TwitterManager {
    
    private var swifter: Swifter
    private var accountsStore: ACAccountStore
    private var accountType: ACAccountType
    private var randomAccount: ACAccount
    
    static let sharedInstance = TwitterManager()
    
    private init() {
        self.swifter = Swifter(consumerKey: Constants.Keys.consumerKey,
                               consumerSecret: Constants.Keys.consumerSecret)
        self.accountsStore = ACAccountStore()
        self.accountType = accountsStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        self.randomAccount = ACAccount()
    }
    
    func isThereAccountSavedInSettings(completion:  @escaping (_ isThereAccountSaved :Bool?, _ isAccessGranted: Bool?)->Void) {
        checkIfApplicationHasAccessToAccounts { [unowned self] (isAccessGranted) in
            
            if isAccessGranted! {
                let twitterAccounts = self.accountsStore.accounts(with: self.accountType)!
                if twitterAccounts.isEmpty {
                    // There is no accounts saved in settings
                    completion(false, true)
                } else {
                    // There is accounts saved in settings
                    let twitterAccount = twitterAccounts[0] as! ACAccount
                    self.randomAccount = twitterAccount
                    completion(true, true)
                }
            } else {
                completion(false, false)
            }
            
        }
    }
    
    func loginToSavedAccount(completion:  @escaping (_ :Bool?)->Void) {
        self.swifter = Swifter(account: self.randomAccount)
        swifter.verifyAccountCredentials(includeEntities: true, skipStatus: true, success: { (jsonObject) in
            let userId = jsonObject["id_str"].string!
            let userDescription = jsonObject["description"].string!
            let userName = jsonObject["name"].string!
            let userFriendsCount = jsonObject["friends_count"].integer!
            let userFollowersCount = jsonObject["followers_count"].integer!
            let currentUser = CurrentUser(userId: userId, userDescription: userDescription, userName: userName, userFriendsCount: userFriendsCount, userFollowersCount: userFollowersCount)
            DBManager.sharedInstance.saveToDatabase(object: currentUser)
            completion(true)
        }) { (error) in
            completion(false)
        }
    }
    
    func loginWithNewAccount(presentFromView: UIViewController, completion:  @escaping (_ :Bool?)->Void) {
        let url = URL(string: "swifter://success")!
        self.swifter.authorize(with: url, presentFrom: presentFromView, success: { _, _ in
            completion(true)
        },failure: { error in
            completion(false)
        })
    }
    
}

// MARK:- Private Functions
extension TwitterManager {
    
    private func checkIfApplicationHasAccessToAccounts(completion:  @escaping (_ :Bool?)->Void) {
        // Prompt the user for permission to their twitter account stored in the phone's settings
        accountsStore.requestAccessToAccounts(with: accountType, options: nil) { granted, error in
            guard granted else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
}





