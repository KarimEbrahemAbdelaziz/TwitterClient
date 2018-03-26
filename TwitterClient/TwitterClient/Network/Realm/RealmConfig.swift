//
//  RealmConfig.swift
//  TwitterClient
//
//  Created by Graphic on 3/26/18.
//  Copyright © 2018 KarimEbrahem. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmConfiguration {
    
    // MARK: - private configurations
    private static let mainConfig = Realm.Configuration(
        schemaVersion: 1,
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
            }
    })
    
    // MARK: - enum cases
    case main
    
    // MARK: - current configuration
    var configuration: Realm.Configuration {
        switch self {
        case .main:
            return RealmConfiguration.mainConfig
        }
    }
    
}
