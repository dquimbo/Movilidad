//
//  LoginError.swift
//  Movilidad
//
//  Created by Diego Quimbo on 24/1/22.
//

import XMLMapper

class ServiceError: XMLMappable {
    var nodeName: String!
    
    var error: ErrorLoginNode!
    var serverError: String!
    var friendlyError: String?
    
    enum Keys: String {
        case Error, ServerError
    }
    
    required init?(map: XMLMap) {}
    
    init(afError: Error) {
        error = ErrorLoginNode(errorDescriptionValue: afError.localizedDescription)
        serverError = ""
    }
    
    func mapping(map: XMLMap) {
        error <- map[Keys.Error.rawValue]
        serverError <- (map[Keys.ServerError.rawValue], XMLCDATATransform())
        
        guard let serverErrorValue = serverError else {
            return
        }
        
        if serverErrorValue.contains("Unknow user or password") {
            friendlyError = L10n.Login.Error.Unknow.credentials
        }
        
        if serverErrorValue.contains("Usuario sin permisos") {
            friendlyError = L10n.Login.Error.No.access
        }
    }
}

class ErrorLoginNode: XMLMappable {
    var nodeName: String!
    
    var errorDescription: String?
    
    required init?(map: XMLMap) {}
    
    init(errorDescriptionValue: String) {
        errorDescription = errorDescriptionValue
    }
    
    func mapping(map: XMLMap) {
        errorDescription <- (map.innerCDATA, XMLCDATATransform())
    }
}
