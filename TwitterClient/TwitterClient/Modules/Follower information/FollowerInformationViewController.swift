//
//  FollowerInformationViewController.swift
//  TwitterClient
//
//  Created by Graphic on 3/29/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import UIKit
import SDWebImage

class FollowerInformationViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileBackgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var follwerName: UILabel!
    @IBOutlet weak var followerHandle: UILabel!
    
    @IBOutlet weak var imagePopupView: UIView!
    @IBOutlet weak var imagePopup: UIImageView!
    var backGroundBlurView: UIVisualEffectView!
    var effect:UIVisualEffect!
    
    var follower: Follower!
    var tweets = [Tweet]()
    
    // Sticky Header Configuration
    private let kTableHeaderCutway: CGFloat = 80.0
    private let kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        backGroundBlurView = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
        effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        backGroundBlurView.effect = nil
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        
        updateHeaderView()
        
        followerHandle.text = follower.followerHandle
        follwerName.text = follower.followerName
        profileImage.sd_setImage(with: URL(string: follower.followerProfileImage))
        profileBackgroundImage.sd_setImage(with: URL(string: follower.followerBackgroundImage), placeholderImage: UIImage(named: "bg-header"))
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProfileImage)))
        profileBackgroundImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showBackgroundImage)))
        imagePopupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        
        getTweets()
    }
    
    @objc func showProfileImage() {
        imagePopup.image = profileImage.image
        self.animateIn()
    }
    
    @objc func showBackgroundImage() {
        imagePopup.image = profileBackgroundImage.image
        self.animateIn()
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add animation to twitter logo
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension FollowerInformationViewController {
    private func animateIn() {
        self.view.addSubview(backGroundBlurView)
        self.view.addSubview(imagePopupView)
        imagePopupView.center = self.view.center
        
        imagePopupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        imagePopupView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.backGroundBlurView.effect = self.effect
            self.imagePopupView.alpha = 1
            self.imagePopupView.transform = CGAffineTransform.identity
        }
        
    }
    
    
    @objc private func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.imagePopupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.imagePopupView.alpha = 0
            
            self.backGroundBlurView.effect = nil
            
        }) { (success:Bool) in
            self.imagePopupView.removeFromSuperview()
            self.backGroundBlurView.removeFromSuperview()
        }
    }
}

extension FollowerInformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func getTweets() {
        TwitterManager.sharedInstance.getUserLatestTweets(userId: follower.followerId) { [unowned self] (tweets, error) in
            if error != nil {
                print("Error")
                return
            }
            
            self.tweets = tweets!
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweetContent.text = tweets[indexPath.row].tweetText
        cell.tweetCreatedAt.text = tweets[indexPath.row].tweetCreatedAt
        return cell
    }
    
}
