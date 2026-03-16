//
//  RealmStorageManager.swift
//  Movilidad
//
//  Created by Diego Quimbo on 2/8/22.
//

import RealmSwift

/// Handle the user and device storage information
final class RealmStorageManager {
   
    class func syncRealmDatabaseWithPlistFile() {
        do {
            let realmSettingsModel = RealmSettingModel.createObjectBy()
            // Save data into Realm database
            let realm = try Realm()
            try realm.write {
                if realm.objects(RealmSettingModel.self).filter("id == %@", "1").first == nil {
                    realm.add(realmSettingsModel)
                    
                    return
                }
            }
        } catch {
            print("There was an error syncing Realm Database")
        }
    }
    
    /// save the server selected to local db
    class func saveServerSelected(serverSelected: String) {
        do {
            // Save data into Realm database
            let realm = try Realm()
            try realm.write {
                guard let settingsData = realm.objects(RealmSettingModel.self).filter("id == %@", "1").first else {
                    print("Server selected was not saved in Realm database")
                    return
                }
                
                settingsData.serverSelected = serverSelected
            }
        } catch {
            print("Server selected was not saved in Realm database")
        }
    }
    
    class func updateServersList(servers: [String], serverSelected: String? = nil) {
        do {
            // Save data into Realm database
            let realm = try Realm()
            try realm.write {
                guard let settingsData = realm.objects(RealmSettingModel.self).filter("id == %@", "1").first else {
                    print("Servers were not saved in Realm database")
                    return
                }
                
                settingsData.servers.removeAll()
                for server in servers {
                    settingsData.servers.append(server)
                }
                
                if let saveServerSelected = serverSelected {
                    settingsData.serverSelected = saveServerSelected
                }
            }
        } catch {
            print("Servers were not saved in Realm database")
        }
    }
    
    /// retrieve the settings from local db
    class func getSettingsData(completion: (_ settings: RealmSettingModel?) -> ()) {
        do {
            // Get user data from Realm database
            let realm = try Realm()
            let realmSettingsModel = realm.objects(RealmSettingModel.self).filter("id == %@", "1").first
    
            completion(realmSettingsModel)
        } catch {
           completion(nil)
        }
    }
    
    /// save the initial profile to local db
    class func saveInitialProfile(profileItemID: String) {
        do {
            // Save data into Realm database
            let realm = try Realm()
            try realm.write {
                guard let settingsData = realm.objects(RealmSettingModel.self).filter("id == %@", "1").first else {
                    print("Setting data was not saved in Realm database")
                    return
                }
                
                settingsData.initialProfileSelectedGuid = profileItemID
                // Remove inital operation
                settingsData.initialOperationSelectedGuid = ""
            }
        } catch {
            print("Setting data was not saved in Realm database (Crash)")
        }
    }
    
    /// save the initial operation to local db
    class func saveInitialOperation(operationItemID: String) {
        do {
            // Save data into Realm database
            let realm = try Realm()
            try realm.write {
                guard let settingsData = realm.objects(RealmSettingModel.self).filter("id == %@", "1").first else {
                    print("Setting data was not saved in Realm database")
                    return
                }
                
                // Save inital operation
                settingsData.initialOperationSelectedGuid = operationItemID
            }
        } catch {
            print("Setting data was not saved in Realm database (Crash)")
        }
    }
    
    /// save the initInMetroDesktop to local db
    class func saveInitInMetroDesktop(initInMetroDesktop: Bool) {
        do {
            // Save data into Realm database
            let realm = try Realm()
            try realm.write {
                guard let settingsData = realm.objects(RealmSettingModel.self).filter("id == %@", "1").first else {
                    print("Setting data was not saved in Realm database - initInMetroDesktop")
                    return
                }
                
                // Save inital operation
                settingsData.initInMetroDesktop = initInMetroDesktop
            }
        } catch {
            print("Setting data was not saved in Realm database (Crash) - initInMetroDesktop")
        }
    }
    
    /// save the initial profile to local db
    class func saveTransactionRedirect(transactionRedirect: String) {
        do {
            // Save data into Realm database
            let realm = try Realm()
            try realm.write {
                guard let settingsData = realm.objects(RealmSettingModel.self).filter("id == %@", "1").first else {
                    print("Setting data was not saved in Realm database")
                    return
                }
                
                settingsData.transactionRedirect = transactionRedirect
            }
        } catch {
            print("Setting data was not saved in Realm database (Crash)")
        }
    }
}
