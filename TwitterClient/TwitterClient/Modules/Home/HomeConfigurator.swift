//
//  HomeConfigurator.swift
//  TwitterClient
//
//  Created by Graphic on 3/30/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation

protocol HomeConfigurator {
    func configure(homeViewController: HomeViewController)
}

class HomeConfiguratorImplementation: HomeConfigurator {
    
    func configure(homeViewController: HomeViewController) {
        
        let realmDatabaseManager = DBManager.sharedInstance
        let twitterUserInformationAPIManager = TwitterManager.sharedInstance
        let router = HomeViewRouterImplementation(homeViewController: homeViewController)
        
        let presenter = HomePresenterImplementation(view: homeViewController,
                                                    realmDBManager: realmDatabaseManager,
                                                    twitterUserInformationAPIManager: twitterUserInformationAPIManager,
                                                    router: router)
        
        homeViewController.presenter = presenter
    }
}
