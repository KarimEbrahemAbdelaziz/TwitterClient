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

protocol LoginTwitterApiManager {
    func isThereAccountSavedInSettings(completion:  @escaping (_ isThereAccountSaved :Bool?, _ isAccessGranted: Bool?)->Void)
    func loginToSavedAccount(completion:  @escaping (_ :Bool?)->Void)
    func loginWithNewAccount(presentFromView: UIViewController, completion:  @escaping (_ :Bool?)->Void)
}

protocol UserInformationApiManager {
    func getCurrentUserInformation(completion:  @escaping (_ : CurrentUser?, _: Error?)->Void)
    func getCurrentUserFollowers(completion:  @escaping (_ : [Follower]?, _: Error?)->Void)
}

class TwitterManager: LoginTwitterApiManager, UserInformationApiManager {
    
    private var swifter: Swifter
    private var accountsStore: ACAccountStore
    private var accountType: ACAccountType
    private var randomAccount: ACAccount
    private var hasPermission: Bool
    
    static let sharedInstance = TwitterManager()
    
    private init() {
        self.swifter = Swifter(consumerKey: Constants.Keys.consumerKey,
                               consumerSecret: Constants.Keys.consumerSecret)
        self.accountsStore = ACAccountStore()
        self.accountType = accountsStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        self.randomAccount = ACAccount()
        hasPermission = false
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
        self.swifter.authorize(with: url, presentFrom: presentFromView, success: { [unowned self] (oauthAccessToken, _) in
            
            if self.hasPermission {
                // Handle has access to AccountStore in settings or on real device
                self.saveAccountToSettings(accessToken: oauthAccessToken!, completion: { (isSaved) in
                    if isSaved! {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                // Handle has not access to AccountStore or on simulator
                completion(true)
            }
            
        }) { (error) in
            completion(false)
        }
    }
    
    func getCurrentUserInformation(completion:  @escaping (_ : CurrentUser?, _: Error?)->Void) {
        swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, success: { (userObject) in
            // Get Cuurent Loged in user information
            let id = userObject["id_str"].string!
            let description = userObject["description"].string!
            let name = userObject["name"].string!
            let friendsCount = userObject["friends_count"].integer!
            let followersCount = userObject["followers_count"].integer!
            let currentUser = CurrentUser(userId: id, userDescription: description, userName: name, userFriendsCount: friendsCount, userFollowersCount: followersCount)
            
            completion(currentUser, nil)
            
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func getCurrentUserFollowers( completion:  @escaping (_ : [Follower]?, _: Error?)->Void) {
        let userId = CurrentUser.getCurrentUserFromDatabase().userId
        swifter.getUserFollowers(for: .id(userId), cursor: nil, count: Constants.UserNumbers.numberOfFollowers, skipStatus: nil, includeUserEntities: nil, success: { (followersObject, _, _) in
            
            var followers = [Follower]()
            let followersArray = followersObject.array
            let _ = followersArray.map({
                $0.map({ follower in
                    let id = follower["id_str"].string!
                    let profileImageUrl = follower["profile_image_url"].string!
                    let backgroundImageUrl = follower["profile_background_image_url"].string ?? nil
                    let name = follower["name"].string!
                    let handle = follower["screen_name"].string!
                    let bio = follower["description"].string!
                    let followeer = Follower(followerId: id, followerProfileImage: profileImageUrl, followerBackgroundImage: backgroundImageUrl, followerName: name, followerHandle: handle, followerBio: bio)
                    followers.append(followeer)
                })
            })
            
            completion(followers, nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func getUserLatestTweets(userId: String, completion:  @escaping (_ : [Tweet]?, _: Error?)->Void) {
        swifter.getTimeline(for: userId, count: Constants.UserNumbers.numberOfTweets, sinceID: nil, maxID: nil, trimUser: nil, contributorDetails: nil, includeEntities: nil, tweetMode: .default, success: { (tweetsObject) in
            
            var tweets = [Tweet]()
            let tweetsArray = tweetsObject.array
            let _ = tweetsArray.map({
                $0.map({ tweet in
                    let id = tweet["id_str"].string!
                    let text = tweet["text"].string!
                    let createdAt = tweet["created_at"].string!
                    let tweeet = Tweet(tweetId: id, tweetText: text, tweetCreatedAt: createdAt)
                    tweets.append(tweeet)
                })
            })
            
            completion(tweets, nil)
            
        }) { (error) in
            completion(nil, error)
        }
    }
    
}

// MARK:- Private Functions
extension TwitterManager {
    
    private func checkIfApplicationHasAccessToAccounts(completion:  @escaping (_ :Bool?)->Void) {
        // Prompt the user for permission to their twitter account stored in the phone's settings
        accountsStore.requestAccessToAccounts(with: accountType, options: nil) { [unowned self] granted, error in
            guard granted else {
                self.hasPermission = false
                completion(false)
                return
            }
            
            self.hasPermission = true
            completion(true)
        }
    }
    
    private func saveAccountToSettings(accessToken: Credential.OAuthAccessToken, completion:  @escaping (_ :Bool?)->Void) {
        let credential = ACAccountCredential(oAuthToken: accessToken.key, tokenSecret: accessToken.secret)
        let accountType = self.accountType
        let newAccount = ACAccount(accountType: accountType)
        newAccount?.credential = credential
        
        self.accountsStore.saveAccount(newAccount) { (isSaved, error) in
            if isSaved {
                // Handle Account Saved Successfull
                completion(true)
            } else {
                // Handle Account Not Saved
                completion(false)
            }
        }
    }
    
}





