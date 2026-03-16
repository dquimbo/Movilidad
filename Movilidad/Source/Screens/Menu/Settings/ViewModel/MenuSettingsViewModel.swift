//
//  MenuSettingsViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 7/2/22.
//

import Foundation

final class MenuSettingsViewModel {
    // Public properties
    var username: String {
        return SessionManager.shared.profile?.additionalProfileInfo?.displayName ?? ""
    }
    
    var initials: String {
        let credentials = Keychain.shared.getUserCredentials()
        
        return credentials?.user ?? ""
    }
    
    var titleProfile: String {
        return SessionManager.shared.profile?.profileSelected?.descripcion ?? ""
    }
    
    var redirectTransaction: String {
        return ""
    }
    
    var language: String {
        return SettingsHandler.shared.language
    }
    
    var server: String {
        return SettingsHandler.shared.serverSelected
    }
    
    var version: String {
        return SettingsHandler.shared.appInfo.version
    }
    
    var build: String {
        return SettingsHandler.shared.appInfo.build
    }
    
    var initialProfile: String {
        return SettingsHandler.shared.getInitialProfile()?.descripcion ?? ""
    }
    
    var initialOperation: String {
        return SettingsHandler.shared.getInitialOperation()?.name ?? ""
    }
    
    var initInMetroDesktop: Bool {
        return SettingsHandler.shared.initInMetroDesktop
    }
    
    var showTransactionRedirect: Bool {
        return SessionManager.shared.profile?.transactionRedirectEnable ?? false
    }
    
    var transactionRedirectSelected: String {
        return SettingsHandler.shared.transactionRedirectSelected
    }
    
    func setInitInMetroDesktop(initMetroDesktop: Bool) {
        SettingsHandler.shared.saveInitInMetroDesktop(initInMetroDesktop: initMetroDesktop)
    }
}
