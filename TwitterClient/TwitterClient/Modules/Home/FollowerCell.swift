//
//  FollowerCell.swift
//  TwitterClient
//
//  Created by Graphic on 3/28/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import UIKit

class ListFollowerCell: UICollectionViewCell {

    @IBOutlet weak var followerImage: UIImageView!
    @IBOutlet weak var followerName: UILabel!
    @IBOutlet weak var followerHandle: UILabel!
    @IBOutlet weak var followerBio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

class GridFollowerCell: UICollectionViewCell {
    
    @IBOutlet weak var followerImage: UIImageView!
    @IBOutlet weak var followerName: UILabel!
    @IBOutlet weak var followerHandle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
