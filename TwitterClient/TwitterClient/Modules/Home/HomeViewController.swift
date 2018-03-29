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
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var followerInfo: Follower!
    var followers = [Follower]()
    var isListView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            isListView = false
            collectionView.reloadData()
        } else {
            print("Portrait")
            isListView = true
            collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getFollowers()
    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        self.logout()
    }
    
}

// MARK:- Handle Fetch Data
extension HomeViewController {
    
    private func getFollowers() {
        TwitterManager.sharedInstance.getCurrentUserFollowers { [unowned self] (followers, error) in
            if error != nil {
                print("Error \(String(describing: error!))")
                return
            }
            
            self.followers = followers!
            self.collectionView.reloadData()
        }
    }
    
}

// MARK:- IBActions
extension HomeViewController {
    
    private func logout() {
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

// MARK:- collectionview Delegate and DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isListView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listFollowerCell", for: indexPath) as! ListFollowerCell
            cell.followerName.text = followers[indexPath.row].followerName
            cell.followerHandle.text = "@" + followers[indexPath.row].followerHandle
            cell.followerBio.text = followers[indexPath.row].followerBio
            cell.followerImage.sd_setImage(with: URL(string: followers[indexPath.row].followerProfileImage))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridFollowerCell", for: indexPath) as! GridFollowerCell
            cell.followerImage.sd_setImage(with: URL(string: followers[indexPath.row].followerProfileImage))
            cell.followerName.text = followers[indexPath.row].followerName
            cell.followerHandle.text = "@" + followers[indexPath.row].followerHandle
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        if isListView {
            let string = followers[indexPath.row].followerBio
            
            let approximateSizeWidth = self.view.frame.width - 68
            let size = CGSize(width: approximateSizeWidth, height: 1000)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
            
            let estmatedFrame = NSString(string: string).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: width, height: estmatedFrame.height + 80)
            
            //return CGSize(width: width, height: 170)
        } else {
            return CGSize(width: (width - 10)/2, height: (width - 20)/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        followerInfo = followers[indexPath.row]
        self.performSegue(withIdentifier: "FollowerInformation_Segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FollowerInformation_Segue" {
            let followerInfoVC = segue.destination as! FollowerInformationViewController
            followerInfoVC.follower = followerInfo
        }
    }
}

















