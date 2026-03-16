//
//  SettingsHandler.swift
//  Movilidad
//
//  Created by Diego Quimbo on 17/1/22.
//

import UIKit
import Foundation

class SettingsHandler {
    // MARK: -  Properties
    var serverSelected = ""
    var servers: [String] = []
    var initialProfileSelectedGuid: String = ""
    var initialOperationSelectedGuid: String = ""
    var initInMetroDesktop: Bool = false
    var transactionRedirectSelected: String = ""
    
    let deviceName = UIDevice.current.userInterfaceIdiom == .pad ? "Desktop-iPad" : "Desktop-iPhone"
    let legalGroup = "ComercialAMI"
    let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var language = "es"
    let appInfo = AppInfo()
    let appName = "MdwClient"
    let settingFileName = "Settings.plist"
    var pushNotificationsToken: String?
    
    // MARK: -  Initializers
    static let shared: SettingsHandler = {
        return SettingsHandler()
    }()
    
    // MARK: - Public Functions
    func loadData() {
        guard let settingsPlist = getSttingsPlistData() else { return }
        
        RealmStorageManager.getSettingsData { settings in
            if let server = settings?.serverSelected {
                serverSelected = server
            }
            
            if let serversSaved = settings?.servers {
                servers = Array(serversSaved)
            }
            
            if let initialProfileGuidSaved = settings?.initialProfileSelectedGuid {
                initialProfileSelectedGuid = initialProfileGuidSaved
            }
            
            if let initialOperationGuidSaved = settings?.initialOperationSelectedGuid {
                initialOperationSelectedGuid = initialOperationGuidSaved
            }
            
            if let initInMetroDesktopSaved = settings?.initInMetroDesktop {
                initInMetroDesktop = initInMetroDesktopSaved
            }
            
            if let transactionRedirect = settings?.transactionRedirect {
                transactionRedirectSelected = transactionRedirect
            }
        }
        
        if let languageSaved = settingsPlist["language"] as? String {
            language = languageSaved
        }
    }
    
    func saveServerSelected(url: String) {
        serverSelected = url
        
        RealmStorageManager.saveServerSelected(serverSelected: url)
    }
    
    func saveServer(url: String?) {
        guard let newServer = url,
              !newServer.isEmpty,
              !servers.contains(where: {$0 == newServer}) else {
                  return
              }
        
        servers.append(newServer)
        serverSelected = newServer
        
        RealmStorageManager.updateServersList(servers: servers, serverSelected: serverSelected)
    }
    
    func deleteServer(url: String) {
        servers = servers.filter({ $0 != url })
        
        // If the user is deleting the actual server selected, try to assign the first in the list
        if serverSelected == url {
            serverSelected = servers.first ?? ""
        }
        
        RealmStorageManager.updateServersList(servers: servers, serverSelected: serverSelected)
    }
    
    // Public Functions
    func saveInitialProfile(profileItemID: String) {
        initialProfileSelectedGuid = profileItemID
        // Remove inital operation
        initialOperationSelectedGuid = ""
        
        RealmStorageManager.saveInitialProfile(profileItemID: profileItemID)
    }
    
    func getInitialProfile() -> ProfileItem? {
        return SessionManager.shared.profile?.profiles?.first(where: { $0.id == self.initialProfileSelectedGuid})
    }
    
    func saveInitialOperation(operationItemID: String) {
        initialOperationSelectedGuid = operationItemID
        
        RealmStorageManager.saveInitialOperation(operationItemID: operationItemID)
    }
    
    func getInitialOperation() -> OperationItem? {
        return SessionManager.shared.getAllOperations()?.first(where: { $0.id == self.initialOperationSelectedGuid})
    }
    
    func saveInitInMetroDesktop(initInMetroDesktop: Bool) {
        self.initInMetroDesktop = initInMetroDesktop
        
        RealmStorageManager.saveInitInMetroDesktop(initInMetroDesktop: initInMetroDesktop)
    }
    
    func saveTransactionRedirect(transactionRedirect: String) {
        transactionRedirectSelected = transactionRedirect
        
        RealmStorageManager.saveTransactionRedirect(transactionRedirect: transactionRedirect)
    }
}

private extension SettingsHandler {
    func getBundleSettingPlistPath() -> String? {
        return Bundle.main.path(forResource: "Settings", ofType: "plist")
    }
    
    func getInternalSettingPlistPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("Settings.plist")
    }
    
    func getSttingsPlistData() -> [String: Any]? {
        let fullPath = getInternalSettingPlistPath()
        
        // If the internal settings file doesn't exist, take the file saved locally and copy it
        if (!FileManager.default.fileExists(atPath: fullPath.path)) {
            if let bundlePath = getBundleSettingPlistPath() {
                do{
                    try FileManager.default.copyItem(atPath: bundlePath, toPath: fullPath.path)
                }catch{
                    print("Settings.plist copy failure.")
                }
            }
        }
        
        guard let settingsPlist = NSMutableDictionary(contentsOfFile: fullPath.path) as? [String: Any] else {
            return nil
        }

        return settingsPlist
    }
}

struct AppInfo {
    var version : String {
        return readFromInfoPlist(withKey: "CFBundleShortVersionString") ?? "(unknown app version)"
    }
    
    var build : String {
        return readFromInfoPlist(withKey: "CFBundleVersion") ?? "(unknown build number)"
    }

    var bundleIdentifier : String {
        return readFromInfoPlist(withKey: "CFBundleIdentifier") ?? "(unknown bundle identifier)"
    }
    
    var buildDate: Date {
        let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as? String ?? "Info.plist"
        
        if let infoPath = Bundle.main.path(forResource: bundleName, ofType: nil),
           let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath),
           let infoDate = infoAttr[FileAttributeKey.creationDate] as? Date
        { return infoDate }
        
        return Date()
    }
    
    // lets hold a reference to the Info.plist of the app as Dictionary
    private let infoPlistDictionary = Bundle.main.infoDictionary
    
    /// Retrieves and returns associated values (of Type String) from info.Plist of the app.
    private func readFromInfoPlist(withKey key: String) -> String? {
        return infoPlistDictionary?[key] as? String
    }
}
