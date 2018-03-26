//
//  LoginViewController.swift
//  TwitterClient
//
//  Created by Graphic on 3/24/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    @IBOutlet weak var twitterLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addPulseAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

// MARK:- IBActions
extension LoginViewController {
    
    @IBAction func LoginAction(_ sender: UIButton) {
        TwitterManager.sharedInstance.isThereAccountSavedInSettings { (isThereIsSavedAccount, isAccessToAccountsGranted) in
            if isThereIsSavedAccount! && isAccessToAccountsGranted! {
                // Handle exist accounts saved on device
                TwitterManager.sharedInstance.loginToSavedAccount(completion: { (isLogined) in
                    if isLogined! {
                        // Handle Login Success
                    } else {
                        // Handle Login Failed
                    }
                })
            } else if !isThereIsSavedAccount! && isAccessToAccountsGranted! {
                // Handle no saved accounts on device
                TwitterManager.sharedInstance.loginWithNewAccount(presentFromView: self, completion: { (isLogined) in
                    if isLogined! {
                        // Handle Login Success
                        print("LLogined")
                    } else {
                        // Handle Login Failed
                        print("Login Fail")
                    }
                })
            } else {
                // No access granted to accounts from user
                
            }
        }
    }
    
}

// MARK:- Add Custom Animation
extension LoginViewController {
    
    private func addPulseAnimation() {
        twitterLogo.addPluseAnimation()
    }
    
}

// MARK:- Safari Delegate
extension LoginViewController: SFSafariViewControllerDelegate {
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}










