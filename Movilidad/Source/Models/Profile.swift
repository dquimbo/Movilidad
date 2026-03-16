//
//  Profile.swift
//  Movilidad
//
//  Created by Diego Quimbo on 26/1/22.
//

import XMLMapper
import Foundation

class Profile: XMLMappable {
    var nodeName: String!
    
    var profiles: [ProfileItem]?
    var profileSelectedGuid: String?
    var licenceServer: String!
    var additionalProfileInfo: AdditionalProfileInfo?
    var transactionRedirectEnable = false
    var transactionRedirectSelectableValues: [TransactionRedirectSelectable]?
    
    private var transactionRedirectItemValues: [TransactionRedirect]?
    
    var profileSelected: ProfileItem? {
        return profiles?.first(where: { $0.id == profileSelectedGuid })
    }
    
    enum Keys: String {
        case profiles = "root.nav.menu.item"
        case profileSelectedGuid = "root.nav.SelectedProfileGuid"
        case licenceServer
        case transactionRedirectValues = "Parameters.Parametro"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        profiles <- map[Keys.profiles.rawValue]
        profileSelectedGuid <- map.attributes[Keys.profileSelectedGuid.rawValue]
        licenceServer <- map[Keys.licenceServer.rawValue]
        
        transactionRedirectItemValues <- map[Keys.transactionRedirectValues.rawValue]
        
        // Transaction Redirect comes form array of items.
        // Item 0 define if transactions redirect are enable and item 1 defines the list of values
        if let transactionValuesUnwrapped = transactionRedirectItemValues, transactionValuesUnwrapped.count >= 2 {
            transactionRedirectEnable = transactionValuesUnwrapped[0].value?.boolValue ?? false
            var transactionValues = transactionValuesUnwrapped[1].value?.components(separatedBy: ",")            
            transactionRedirectSelectableValues = transactionValues?.map({ value in
                return TransactionRedirectSelectable(value: value)
            })
        }
    }
}

class TransactionRedirectSelectable: SelectItemProtocol {
    let value: String
    
    init(value: String) {
        self.value = value
    }
    
    // SelectItemProtocol
    func getID() -> String {
        return value
    }
    
    func getTitle() -> String {
        return value
    }
}

class TransactionRedirect: XMLMappable {
    var nodeName: String!
    
    var name: String?
    var value: String?
    
    enum Keys: String {
        case name = "Nombre"
        case value = "Valor"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        name <- map.attributes[Keys.name.rawValue]
        value <- map.attributes[Keys.value.rawValue]
    }
}

class ProfileItem: XMLMappable, SelectItemProtocol {
    var nodeName: String!
    
    var id: String?
    var descripcion: String?
    
    enum Keys: String {
        case id, descripcion
    }
    
    init(id: String, description: String) {
        self.id = id
        self.descripcion = description
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        id <- map.attributes[Keys.id.rawValue]
        descripcion <- map.attributes[Keys.descripcion.rawValue]
    }
    
    // SelectItemProtocol
    func getID() -> String {
        return id ?? ""
    }
    
    func getTitle() -> String {
        return descripcion ?? ""
    }
}

class AdditionalProfileInfo: XMLMappable {
    var nodeName: String!
    
    var username: String?
    var accountName: String?
    var name: String?
    var displayName: String?
    var title: String?
    
    enum Keys: String {
        case username = "userinfo.username"
        case accountName = "userinfo.accountname"
        case name = "userinfo.name"
        case displayName = "userinfo.displayname"
        case title = "userinfo.title"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        username <- map.attributes[Keys.username.rawValue]
        accountName <- map.attributes[Keys.accountName.rawValue]
        name <- map.attributes[Keys.name.rawValue]
        displayName <- map.attributes[Keys.displayName.rawValue]
        title <- map.attributes[Keys.title.rawValue]
    }
}
