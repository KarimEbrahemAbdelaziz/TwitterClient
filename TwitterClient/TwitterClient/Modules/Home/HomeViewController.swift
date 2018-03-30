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
    
    // MARK:- Properties
    var configurator = HomeConfiguratorImplementation()
    var presenter: HomePresenter!
    let loadingHud = LoadingHud.sharedLoadingHud
    private let refreshControl = UIRefreshControl()
    private var follower: Follower!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configurator.configure(homeViewController: self)
        presenter.viewDidLoad()
    }
    
    @objc private func refreshFollowersData(_ sender: Any) {
        // Fetch Weather Data
        presenter.getFollowers()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            presenter.switchOrintation()
        } else {
            presenter.switchOrintation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        presenter.logout()
    }
    
}

// MARK:- collectionview Delegate and DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.followersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if presenter.isList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listFollowerCell", for: indexPath) as! ListFollowerCell
            presenter.configureListCell(listCell: cell, row: indexPath.row)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridFollowerCell", for: indexPath) as! GridFollowerCell
            presenter.configureGridCell(gridCell: cell, row: indexPath.row)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        if presenter.isList {
            let string = presenter.currentFollowerBio(row: indexPath.row)
            
            let approximateSizeWidth = self.view.frame.width - 68
            let size = CGSize(width: approximateSizeWidth, height: 1000)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
            
            let estmatedFrame = NSString(string: string).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: width, height: estmatedFrame.height + 80)
        } else {
            return CGSize(width: (width - 10)/2, height: (width - 20)/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(presenter.minimumLineSpacingForSection)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectItemAt(row: indexPath.row)
    }
    
}

// MARK:- HomeView Protocol methods
extension HomeViewController: HomeView {
    
    func goToFollowerInfo(follower: Follower) {
        self.follower = follower
        self.performSegue(withIdentifier: "FollowerInformation_Segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FollowerInformation_Segue" {
            let followerInfoVC = segue.destination as! FollowerInformationViewController
            followerInfoVC.follower = self.follower
        }
    }
    
    func setupViews() {
        setupNavigationBarView()
        setupRefreshControl()
    }
    
    func endRefreshControl() {
        self.refreshControl.endRefreshing()
    }
    
    func refreshCollectionView() {
        self.collectionView.reloadData()
    }
    
    private func setupNavigationBarView() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = UIColor.white
        let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Followers...", attributes: myAttribute)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshFollowersData(_:)), for: .valueChanged)
    }
}

















