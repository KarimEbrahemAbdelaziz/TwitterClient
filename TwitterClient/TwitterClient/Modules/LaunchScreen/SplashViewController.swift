//
//  LaunchViewController.swift
//  TwitterClient
//
//  Created by Graphic on 3/28/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfThereIsLogedinAccount()
    }
    
    private func checkIfThereIsLogedinAccount() {
        let userId = DBManager.sharedInstance.getAllFromDatabase(ofType: CurrentUser.self).first?.userId
        if userId == nil || (userId?.isEmpty)! {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewContoller = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            present(loginViewContoller, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewContoller = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            present(loginViewContoller, animated: true, completion: nil)
        }
    }

}
