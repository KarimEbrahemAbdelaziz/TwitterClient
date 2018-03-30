//
//  FollowerCell.swift
//  TwitterClient
//
//  Created by Graphic on 3/28/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import UIKit

class ListFollowerCell: UICollectionViewCell, ListCell {

    @IBOutlet weak var followerImage: UIImageView!
    @IBOutlet weak var followerName: UILabel!
    @IBOutlet weak var followerHandle: UILabel!
    @IBOutlet weak var followerBio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureListCell(model: Follower) {
        self.followerName.text = model.followerName
        self.followerHandle.text = "@" + model.followerHandle
        self.followerBio.text = model.followerBio
        self.followerImage.sd_setImage(with: URL(string: model.followerProfileImage))
    }

}

class GridFollowerCell: UICollectionViewCell, GridCell {
    
    @IBOutlet weak var followerImage: UIImageView!
    @IBOutlet weak var followerName: UILabel!
    @IBOutlet weak var followerHandle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureGridCell(model: Follower) {
        self.followerImage.sd_setImage(with: URL(string: model.followerProfileImage))
        self.followerName.text = model.followerName
        self.followerHandle.text = "@" + model.followerHandle
    }
    
}
