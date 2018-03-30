//
//  HomeViewRouter.swift
//  TwitterClient
//
//  Created by Graphic on 3/30/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import UIKit

protocol HomeViewRouter: ViewRouter {
    func showLoadingHud()
    func dismissLoadingHud()
    func presentAlert(title: String, message: String)
    func dismissViewController()
}

class HomeViewRouterImplementation: HomeViewRouter {
    
    fileprivate weak var homeViewController: HomeViewController?
    private var follower: Follower!
    
    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
    }
    
    // MARK: - BooksViewRouter
    
    func showLoadingHud() {
        homeViewController?.loadingHud.show(in: (homeViewController?.view)!)
    }
    
    func dismissLoadingHud() {
        homeViewController?.loadingHud.dismiss()
    }
    
    func presentAlert(title: String, message: String) {
        let alert = Helpers.alert(title: title, message: message)
        homeViewController?.present(alert, animated: true, completion: nil)
    }
    
    func dismissViewController() {
        homeViewController?.dismiss(animated: true, completion: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
