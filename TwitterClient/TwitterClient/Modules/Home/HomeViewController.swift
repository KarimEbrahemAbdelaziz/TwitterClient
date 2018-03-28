//
//  HomeViewController.swift
//  TwitterClient
//
//  Created by Graphic on 3/27/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import UIKit
import Accounts
import RealmSwift

class HomeViewController: UIViewController {
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK:- IBActions
extension HomeViewController {
    
    @IBAction func logoutAction(_ sender: UIButton) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        let twitterAccounts = accountStore.accounts(with: accountType)!
        
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
        
        accountStore.removeAccount(accountToRemove) { (isDeleted, error) in
            if error != nil {
                print(error!)
                return
            }
                
            if isDeleted {
                print("Deleted Success")
                let realm = try! Realm()
                try? realm.write {
                    realm.deleteAll()
                }
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Deleted Failed")
            }
        }
        
    }
    
}



















