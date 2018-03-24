//
//  Constants.swift
//  TwitterClient
//
//  Created by Graphic on 3/24/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation

class Constants {
    
    struct Keys {
        static let consumerKey = "TmOyeB1v0kVHKSzG3VLZWcyYr"
        static let consumerSecret = "iuLEnwb6rnbs1vdZFh3jUOw24zNGMu2NcvYCvzgmE1PKYaCL5X"
    }
    
    struct URLs {
        static let baseURL = "https://api.twitter.com/"
        static let requestTokenUrl = baseURL + "oauth/request_token"
        static let authorizeUrl = baseURL + "oauth/authorize"
        static let accessTokenUrl = baseURL + "oauth/access_token"
    }
    
}
