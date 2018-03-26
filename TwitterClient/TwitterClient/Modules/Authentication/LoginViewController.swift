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

    // MARK:- IBOutlets
    @IBOutlet weak var twitterLogo: UIImageView!
    
    // MARK:- Prop
    let loadingHud = LoadingHud.sharedLoadingHud
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add animation to twitter logo
        addPulseAnimation()
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
        loadingHud.show(in: self.view)
        TwitterManager.sharedInstance.isThereAccountSavedInSettings { [unowned self] (isThereIsSavedAccount, isAccessToAccountsGranted) in
            if isThereIsSavedAccount! && isAccessToAccountsGranted! {
                // Handle exist accounts saved on device
                TwitterManager.sharedInstance.loginToSavedAccount(completion: { [unowned self] (isLogined) in
                    if isLogined! {
                        // Handle Login Success
                        self.loadingHud.dismiss()
                        print("Logined")
                    } else {
                        // Handle Login Failed
                        self.loadingHud.dismiss()
                        print("Login Fail")
                    }
                })
            } else if !isThereIsSavedAccount! && isAccessToAccountsGranted! {
                // Handle no saved accounts on device
                TwitterManager.sharedInstance.loginWithNewAccount(presentFromView: self, completion: { (isLogined) in
                    if isLogined! {
                        // Handle Login Success
                        self.loadingHud.dismiss()
                        print("Logined")
                    } else {
                        // Handle Login Failed
                        self.loadingHud.dismiss()
                        print("Login Fail")
                    }
                })
            } else {
                // No access granted to accounts from user
                self.loadingHud.dismiss()
                let alert = Helpers.alert(title: "Access Error", message: "There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
                self.present(alert, animated: true, completion: nil)
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










