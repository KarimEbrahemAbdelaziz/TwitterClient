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
    
    // MARK:- Properties
    var configurator = LoginConfiguratorImplementation()
    var presenter: LoginPresenter!
    let loadingHud = LoadingHud.sharedLoadingHud
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configurator.configure(loginViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add animation to twitter logo
        presenter.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        presenter.viewWillDisappear()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

}

// MARK:- IBActions
extension LoginViewController {
    
    @IBAction func LoginAction(_ sender: UIButton) {
        presenter.showLoadingHud()
        presenter.login()
    }
    
}

// MARK:- LoginView Protocol methods
extension LoginViewController: LoginView {
    
    func addAnimationToLogo() {
        twitterLogo.addPluseAnimation()
    }
    
    func hideNavigationbar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showNavigationbar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}

// MARK:- Safari Delegate
extension LoginViewController: SFSafariViewControllerDelegate {
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}










