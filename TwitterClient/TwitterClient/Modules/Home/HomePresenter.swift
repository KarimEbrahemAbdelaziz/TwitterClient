//
//  HomePresenter.swift
//  TwitterClient
//
//  Created by Graphic on 3/30/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation
import Accounts
import RealmSwift

// View Protocol to call view methods
protocol HomeView: class {
    func setupViews()
    func endRefreshControl()
    func refreshCollectionView()
    func goToFollowerInfo(follower: Follower)
}

protocol GridCell {
    func configureGridCell(model: Follower)
}

protocol ListCell {
    func configureListCell(model: Follower)
}

// Presenter Protocol to call presenter methods
protocol HomePresenter {
    var router: HomeViewRouter { get }
    var followersCount: Int { get }
    var minimumLineSpacingForSection: Int { get }
    var isList: Bool { get }
    func currentFollowerBio(row: Int) -> String
    func showLoadingHud()
    func dismissLoadingHud()
    func presentAlert(title: String, message: String)
    func viewDidLoad()
    func viewDidAppear()
    func getFollowers()
    func logout()
    func endRefreshControl()
    func switchOrintation()
    func configureListCell(listCell: ListCell, row: Int)
    func configureGridCell(gridCell: GridCell, row: Int)
    func selectItemAt(row: Int)
    func getFollowersInternet(completion:  @escaping (_ : Bool)->Void)
}

class HomePresenterImplementation: HomePresenter {
    
    fileprivate weak var view: HomeView?
    internal let router: HomeViewRouter
    fileprivate let realmDBManager: UserDatabaseManager
    fileprivate let twitterUserInformationAPIManager: UserInformationApiManager
    
    // Normally add model here and would be file private as well
    fileprivate var followerInfo: Follower!
    fileprivate var followers: Results<Follower>!
    fileprivate var isListView = true
    
    init(view: HomeView,
         realmDBManager: UserDatabaseManager,
         twitterUserInformationAPIManager: UserInformationApiManager,
         router: HomeViewRouter) {
        self.view = view
        self.realmDBManager = realmDBManager
        self.twitterUserInformationAPIManager = twitterUserInformationAPIManager
        self.router = router
    }
    
    // MARK: - LoginPresenter
    var followersCount: Int {
        return followers != nil ? followers.count : 0
    }
    
    var isList: Bool {
        return isListView ? true : false
    }
    
    var minimumLineSpacingForSection: Int {
        return 0
    }
    
    func currentFollowerBio(row: Int) -> String {
        return followers[row].followerBio
    }
    
    func viewDidLoad() {
        getFollowersInternet { [unowned self] (isUpdated) in
            self.getFollowers()
        }
        view?.setupViews()
    }
    
    func viewDidAppear() {
        //getFollowers()
    }
    
    func getFollowers() {
        showLoadingHud()
        let followers = realmDBManager.getFollowersFromDatabase()
        self.followers = followers
        self.endRefreshControl()
        dismissLoadingHud()
        view?.refreshCollectionView()
    }
    
    func getFollowersInternet(completion:  @escaping (_ : Bool)->Void) {
        showLoadingHud()
        twitterUserInformationAPIManager.getCurrentUserFollowers { [unowned self] (followers, error) in
            if error != nil {
                completion(false)
                return
            }
            
            self.saveFollowersLocal(followers: followers!)
            completion(true)
        }
    }
    
    func logout() {
        showLoadingHud()
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        if let twitterAccounts = accountStore.accounts(with: accountType) {
        
            let currentAccountName = CurrentUser.getCurrentUserFromDatabase().userName
            var accountToRemove = ACAccount()
            for account in twitterAccounts {
                let accountInSettings = account as! ACAccount
                print(accountInSettings.userFullName)
                if accountInSettings.userFullName == currentAccountName {
                    accountToRemove = accountInSettings
                    break
                }
            }
        
            accountStore.removeAccount(accountToRemove) { [unowned self] (isDeleted, error) in
                if error != nil {
                    self.dismissLoadingHud()
                    self.presentAlert(title: "Error", message: "Can't logout.")
                    return
                }
            
                if isDeleted {
                    self.dismissLoadingHud()
                    let realm = try! Realm()
                    try? realm.write {
                        realm.deleteAll()
                    }
                    self.router.dismissViewController()
                } else {
                    self.dismissLoadingHud()
                    self.presentAlert(title: "Error", message: "Can't logout.")
                }
            }
        } else {
            self.dismissLoadingHud()
            let realm = try! Realm()
            try? realm.write {
                realm.deleteAll()
            }
            self.router.dismissViewController()
        }
    }
    
    func endRefreshControl() {
        view?.endRefreshControl()
    }
    
    func showLoadingHud() {
        router.showLoadingHud()
    }
    
    func dismissLoadingHud() {
        router.dismissLoadingHud()
    }
    
    func switchOrintation() {
        isListView = isListView ? false : true
        view?.refreshCollectionView()
    }
    
    func configureGridCell(gridCell: GridCell, row: Int) {
        gridCell.configureGridCell(model: followers[row])
    }
    
    func configureListCell(listCell: ListCell, row: Int) {
        listCell.configureListCell(model: followers[row])
    }
    
    func selectItemAt(row: Int) {
        view?.goToFollowerInfo(follower: followers[row])
    }
    
    func presentAlert(title: String, message: String) {
        router.presentAlert(title: title, message: message)
    }
    
    // MARK:- Private Functions
    fileprivate func saveFollowersLocal(followers: [Follower]) {
        realmDBManager.saveFollowersToDatabase(followers: followers)
        dismissLoadingHud()
    }
    
}
