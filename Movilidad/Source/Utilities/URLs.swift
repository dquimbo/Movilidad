//
//  URLs.swift
//  MovilidadUK
//
//  Created by Diego Quimbo on 4/1/22.
//

import Foundation

struct URLs {
    static func baseURL() -> String {
        return "https://\(SettingsHandler.shared.serverSelected)"
    }
    
    struct Auth {
        static func login() -> String {
            return "\(baseURL())/Desktop/SecureLogin.axd?Command=FormsAuth"
        }
    }
    
    struct Profile {
        private static let deviceName = SettingsHandler.shared.deviceName
        private static let legalGroup = SettingsHandler.shared.legalGroup
        private static let deviceId = SettingsHandler.shared.deviceId
        private static let appName = SettingsHandler.shared.appName
        private static let credentials = Keychain.shared.getUserCredentials()

        static func profile() -> String {
            return "\(baseURL())/Desktop/W32LoadDesktop.axd?Id=0&Command=Profiles&Initial_Load=True&Culture=es-AR&ClientType=\(Profile.deviceName)&legalGroup=\(Profile.legalGroup)&deviceId=\(Profile.deviceId)"
        }
        
        static func menu(profile: String) -> String {
            return "\(baseURL())/Desktop/W32LoadDesktop.axd?Id=0&Command=DesktopData&Initial_Load=False&Culture=es-AR&ClientType=\(Profile.deviceName)&legalGroup=\(Profile.legalGroup)&deviceId=\(Profile.deviceId)&Profile=\(profile)"
        }
        
        static func profileExtraInfo() -> String {
            return "\(baseURL())/Desktop/UserSettings.axd?getuserinfo"
        }
        
        static let registerPushNotifications =  "http://\(SettingsHandler.shared.serverSelected)/OT.Ternium.PushNotification.Web/api/pushnotification/register"
        
        static func notificationsCount() -> String {
            let username = credentials?.user ?? ""
            let url = "http://\(SettingsHandler.shared.serverSelected)/OT.Ternium.PushNotification.Web/api/pushnotification/getnotificationscount?user=Ternium\\\(username)&appName=\(Profile.appName)"
            return url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) ?? ""
        }
        
        static func profilePhoto(username: String) -> String {
            return "\(baseURL())/desktop/UserSettings.axd?getuserphoto&username=\(username)"
        }
    }
    
    struct Operation {
        private static let appName = SettingsHandler.shared.appName
        private static let credentials = Keychain.shared.getUserCredentials()
        
        static func operation(guid: String) -> String {
            return "\(baseURL())/OperationsXPRuntime/OperationEngine.aspx?guid=\(guid)"
        }
        
        static func externalOperationWorkflow(id: String) -> String {
            switch id {
            case "Intra":
                return "http://intramobile.ternium.net/"
            case "Norte":
                return "http://workflow-mx.ternium.net"
            case "Sur":
                return "http://workflow-ar.ternium.net"
            case "Desarrollo":
                return "http://termxsvcexwf01.ternium.techint.net/SiteGestionMobile/html/workflow/workflowios.aspx"
            default:
                return ""
            }
        }
        
        static func notificationsWebView() -> String {
            let username = credentials?.user ?? ""
            let url = "http://\(SettingsHandler.shared.serverSelected)/OT.Ternium.PushNotification.Web/MessageInbox?user=ternium\\\(username)&appName=\(Operation.appName)"
            return url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) ?? ""
        }
        
        static func getTiles(guid: String) -> String {
            return "\(baseURL())/OperationsXPRuntime/OperationEngine.aspx?guid=\(guid)&location="
        }
    }
}
