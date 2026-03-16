//
//  ConnectionManager.swift
//  MovilidadUK
//
//  Created by Diego Quimbo on 4/1/22.
//

import Foundation
import Alamofire

enum ApiError: Error {
    case internalServerError 
}

class ConnectionManager: NSObject {
    
    static let headers: HTTPHeaders = [
        .contentType("application/x-www-form-urlencoded"),
        .userAgent("mdwclient"),
        .acceptLanguage("es"),
        .mdwclientCapabilities("gzip-compression"),
        .mdwclientCapabilities("nonserialize-xml"),
        .mdwclientDevice(),
        .mdwclientVersion(),
        .ipadclient()
    ]
    
    static let headersPushNotifications: HTTPHeaders = [
        .contentType("application/json; charset=utf-8"),
        .userAgent("mdwclient"),
        .acceptLanguage("es"),
        .mdwclientCapabilities("gzip-compression"),
        .mdwclientCapabilities("nonserialize-xml"),
        .mdwclientDevice(),
        .mdwclientVersion(),
        .ipadclient()
    ]
    
    static let domain = "Ternium"
    
    var session: Session = {
        let server = SettingsHandler.shared.serverSelected
        let manager = ServerTrustManager(evaluators: [server: DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    
    func refreshTrustServer() {
        let server = SettingsHandler.shared.serverSelected
        let manager = ServerTrustManager(evaluators: [server: DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        session = Session(configuration: configuration, serverTrustManager: manager)
    }
}
