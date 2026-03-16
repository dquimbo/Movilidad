//
//  Operation.swift
//  Movilidad
//
//  Created by Diego Quimbo on 25/2/22.
//

import XMLMapper

class OperationWeb: XMLMappable {
    var nodeName: String!
    
    var url = ""
    var isExternal = false
    
    enum Keys: String {
        case url = "url"
    }
    
    required init?(map: XMLMap) {}
    
    required init(workflowId: String) {
        url = URLs.Operation.externalOperationWorkflow(id: workflowId)
        isExternal = true
    }
    
    required init(externalURL: String) {
        url = externalURL
        isExternal = true
    }
    
    func mapping(map: XMLMap) {
        url <- map.attributes[Keys.url.rawValue]
        isExternal = url.hasPrefix("http")
    }
}
