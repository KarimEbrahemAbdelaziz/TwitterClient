//
//  LoadingHud.swift
//  TwitterClient
//
//  Created by Graphic on 3/26/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation
import JGProgressHUD

class LoadingHud {
    
    static let sharedLoadingHud = LoadingHud().loadingHud
    
    // MARK: -
    
    let loadingHud: JGProgressHUD
    
    // Initialization
    
    private init() {
        self.loadingHud = JGProgressHUD(style: .dark)
        self.loadingHud.textLabel.text = "Loading..."
    }
    
}
