//
//  RealmSettingsModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 2/8/22.
//

import RealmSwift
import Foundation

/// Realm User Model - a local db containing the User Profile info. THis will eventually be replaced with API calls to our Cloud
class RealmSettingModel: Object {
    @objc dynamic var id = "1"
    @objc dynamic var serverSelected = ""
    @objc dynamic var initialProfileSelectedGuid = ""
    @objc dynamic var initialOperationSelectedGuid: String = ""
    @objc dynamic var initInMetroDesktop: Bool = false
    @objc dynamic var transactionRedirect: String = ""
    let servers = List<String>()

    /// Convert SettingsHandler to Realm Settings Model
    static func createObjectBy() -> RealmSettingModel {
        let realmSetting = RealmSettingModel()
        guard let settingsPlist = Utilities.getSttingsPlistData() else {
            return realmSetting
        }
        
        if let serversSaved = settingsPlist["servers"] as? [String] {
            realmSetting.serverSelected = serversSaved[0]
            
            for server in serversSaved {
                realmSetting.servers.append(server)
            }
        }
        
        return realmSetting
    }
}

