//
//  LoginConfigurator.swift
//  TwitterClient
//
//  Created by Graphic on 3/26/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation

protocol LoginConfigurator {
    func configure(loginViewController: LoginViewController)
}

class LoginConfiguratorImplementation: LoginConfigurator {
    
    func configure(loginViewController: LoginViewController) {
        
        let realmDatabaseManager = DBManager.sharedInstance
        let twitterLoginAPIManager = TwitterManager.sharedInstance
        let twitterUserInformationAPIManager = TwitterManager.sharedInstance
        let router = LoginViewRouterImplementation(loginViewController: loginViewController)
        
        let presenter = LoginPresenterImplementation(view: loginViewController,
                                                     realmDBManager: realmDatabaseManager,
                                                     twitterLoginAPIManager: twitterLoginAPIManager,
                                                     twitterUserInformationAPIManager: twitterUserInformationAPIManager,
                                                     router: router)
        
        loginViewController.presenter = presenter
    }
}
