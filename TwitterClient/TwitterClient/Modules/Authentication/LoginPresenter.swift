//
//  LoginPresenter.swift
//  TwitterClient
//
//  Created by Graphic on 3/26/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation
import UIKit

// View Protocol to call view methods
protocol LoginView: class {
    func addAnimationToLogo()
    func hideNavigationbar()
    func showNavigationbar()
}

// Presenter Protocol to call presenter methods
protocol LoginPresenter {
    var router: LoginViewRouter { get }
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func showLoadingHud()
    func dismissLoadingHud()
    func presentAlert(title: String, message: String)
    func login()
}

class LoginPresenterImplementation: LoginPresenter {
    
    fileprivate weak var view: LoginView?
    internal let router: LoginViewRouter
    fileprivate let realmDBManager: LoginDatabaseManager
    fileprivate let twitterLoginAPIManager: LoginTwitterApiManager
    fileprivate let twitterUserInformationAPIManager: UserInformationApiManager
    
    // Normally add model here and would be file private as well
    
    init(view: LoginView,
         realmDBManager: LoginDatabaseManager,
         twitterLoginAPIManager: LoginTwitterApiManager,
         twitterUserInformationAPIManager: UserInformationApiManager,
         router: LoginViewRouter) {
        self.view = view
        self.realmDBManager = realmDBManager
        self.twitterLoginAPIManager = twitterLoginAPIManager
        self.twitterUserInformationAPIManager = twitterUserInformationAPIManager
        self.router = router
    }
    
    // MARK: - LoginPresenter
    
    func viewWillAppear() {
        view?.hideNavigationbar()
    }
    
    func viewDidAppear() {
        view?.addAnimationToLogo()
    }
    
    func viewWillDisappear() {
        view?.showNavigationbar()
    }
    
    func showLoadingHud() {
        router.showLoadingHud()
    }
    
    func dismissLoadingHud() {
        router.dismissLoadingHud()
        view?.addAnimationToLogo()
    }
    
    func presentAlert(title: String, message: String) {
        router.presentAlert(title: title, message: message)
    }
    
    func login() {
        twitterLoginAPIManager.isThereAccountSavedInSettings { [unowned self] (isThereIsSavedAccount, isAccessToAccountsGranted) in
            if isThereIsSavedAccount! && isAccessToAccountsGranted! {
                // Handle exist accounts saved on device
                self.handleExistAccountOnDeviceLogin()
                
            } else if !isThereIsSavedAccount! && isAccessToAccountsGranted! {
                // Handle no saved accounts on device
                self.handleNoAccountOnDeviceLogin()
                
            } else {
                // No access granted to accounts from user
                self.handleNoAccess()
            }
        }
    }
    
    // MARK:- Private Functions
    
    fileprivate func handleExistAccountOnDeviceLogin() {
        twitterLoginAPIManager.loginToSavedAccount(completion: { [unowned self] (isLogined) in
            if isLogined! {
                // Save current user data to Realm Database
                self.saveUserInfoToLocalDatabase()
            } else {
                // Handle Login Failed
                self.router.dismissLoadingHud()
                self.router.presentAlert(title: "Login Error", message: "Can't login to twitter. Please try again later.")
            }
        })
    }
    
    fileprivate func handleNoAccountOnDeviceLogin() {
        twitterLoginAPIManager.loginWithNewAccount(presentFromView: self.view as! UIViewController, completion: { [unowned self] (isLogined) in
            if isLogined! {
                // Save current user data to Realm Database
                self.saveUserInfoToLocalDatabase()
            } else {
                // Handle Login Failed
                self.router.dismissLoadingHud()
                self.router.presentAlert(title: "Login Error", message: "Can't login to twitter. Please try again later.")
            }
        })
    }
    
    fileprivate func handleNoAccess() {
        handleNoAccountOnDeviceLogin()
    }
    
    fileprivate func saveUserInfoToLocalDatabase() {
        twitterUserInformationAPIManager.getCurrentUserInformation { [unowned self] (currentUser, error) in
            if error != nil {
                self.router.presentAlert(title: "Connection Error", message: "Can't get user information from twitter. Please try again later.")
                return
            }
            
            self.realmDBManager.resetDatabase()
            self.realmDBManager.saveToDatabase(object: currentUser!)
            
            // Handle Login Success
            self.router.dismissLoadingHud()
            // Navigate to HomeVC
            self.router.presentHomeView()
        }
    }
    
}
