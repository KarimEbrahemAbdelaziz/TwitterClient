//
//  LoginViewRouter.swift
//  TwitterClient
//
//  Created by Graphic on 3/26/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import UIKit

protocol LoginViewRouter: ViewRouter {
    func showLoadingHud()
    func dismissLoadingHud()
    func presentAlert(title: String, message: String)
    func presentHomeView()
}

class LoginViewRouterImplementation: LoginViewRouter {
    
    fileprivate weak var loginViewController: LoginViewController?
    
    init(loginViewController: LoginViewController) {
        self.loginViewController = loginViewController
    }
    
    // MARK: - BooksViewRouter
    
    func presentHomeView() {
        loginViewController?.performSegue(withIdentifier: "HomeView_Segue", sender: self)
    }
    
    func showLoadingHud() {
        loginViewController?.loadingHud.show(in: (loginViewController?.view)!)
    }
    
    func dismissLoadingHud() {
        loginViewController?.loadingHud.dismiss()
    }
    
    func presentAlert(title: String, message: String) {
        let alert = Helpers.alert(title: title, message: message)
        loginViewController?.present(alert, animated: true, completion: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
