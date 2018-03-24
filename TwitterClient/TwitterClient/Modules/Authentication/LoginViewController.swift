//
//  LoginViewController.swift
//  TwitterClient
//
//  Created by Graphic on 3/24/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import UIKit
import Accounts
import TwitterKit

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
        APIManager.sharedInstance.login { (isLogined, error) in
            if error != nil {
                print("Error")
                return
            }
            
            if isLogined! {
                print("Login Success")
            } else {
                print("Login Failed")
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












