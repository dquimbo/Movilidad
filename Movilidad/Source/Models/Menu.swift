//
//  Menu.swift
//  Movilidad
//
//  Created by Diego Quimbo on 28/1/22.
//

import XMLMapper

class Menu: XMLMappable {
    var nodeName: String!
    
    var sectionItems: [SectionItem] = []
    
    enum Keys: String {
        case sectionItems = "items.item"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        sectionItems <- map[Keys.sectionItems.rawValue]
    }
    
    func getAllMenuItems() -> [OperationItem] {
        // Get all operations
        var items: [OperationItem] = []
        for section in sectionItems {
            items.append(contentsOf: section.getAllMenuItemsForSection())
        }
        
        return items
    }
    
    func getALLOperationItemsInNullableSections() -> [OperationItem] {
        // Get all operations
        var items: [OperationItem] = []
        for section in sectionItems {
            items.append(contentsOf: section.getAllItemsInNullableSection())
        }
        
        return items
    }
}

class SectionItem: XMLMappable {
    var nodeName: String!
    
    var name: String?
    var sectionContent: [SectionContent] = []
    var sectionContentNullable: [SectionContent] = []
    var filteredItems: [OperationItem] = []
    
    enum Keys: String {
        case name
        case sectionContent = "item"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        name <- map.attributes[Keys.name.rawValue]
        
        sectionContent <- map[Keys.sectionContent.rawValue]
        sectionContentNullable <- map[Keys.sectionContent.rawValue]
    }
    
    init(name: String?, sectionContent: [SectionContent], filteredItems: [OperationItem]) {
        self.name = name
        self.sectionContent = sectionContent
        self.filteredItems = filteredItems
    }

    func copy() -> SectionItem {
        let copy = SectionItem(name: name, sectionContent: sectionContent, filteredItems: filteredItems)
        return copy
    }
    
    func getAllMenuItemsForSection() -> [OperationItem] {
        // Get all items associated to sections
        var items: [OperationItem] = []
        
        for sectionContent in sectionContent {
            items.append(contentsOf: sectionContent.items)
        }
        
        return items
    }
    
    func getAllItemsInNullableSection() -> [OperationItem] {
        // Get all items associated to sections
        var items: [OperationItem] = []

        for sectionContent in sectionContentNullable {
            items.append(contentsOf: sectionContent.getAllItemsInNullableSections())
        }

        return items
    }
}

class SectionContent: XMLMappable {
    var nodeName: String!
    
    var name: String?
    var items: [OperationItem] = []
    // This property try to get all operations nodes regardless if the node has value or not
    var sectionItemsNullable: [SectionItemNullable] = []
    
    // This property is only used to get all items through nodes
    private var itemsBridged: [SectionContentBridged] = []
    
    enum Keys: String {
        case name
        case sectionItemsNullable = "item"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        name <- map.attributes[Keys.name.rawValue]
        sectionItemsNullable <- map[Keys.sectionItemsNullable.rawValue]
        
        itemsBridged <- map[Keys.sectionItemsNullable.rawValue]
        itemsBridged = itemsBridged.filter( {$0.items.count != 0})
        
        // Get all operation items
        items = itemsBridged.flatMap({ element in
            return element.items
        })
    }
    
    func getAllItemsInNullableSections() -> [OperationItem] {
        var items: [OperationItem] = []

        for sectionItemNullable in sectionItemsNullable {
            items.append(contentsOf: sectionItemNullable.items)
        }

        return items
    }
}

class SectionContentBridged: XMLMappable {
    var nodeName: String!
    
    var name: String?
    var items: [OperationItem] = []
    
    enum Keys: String {
        case name
        case items = "item"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        name <- map.attributes[Keys.name.rawValue]
        items <- map[Keys.items.rawValue]
    }
}

class SectionItemNullable: XMLMappable {
    var nodeName: String!
    
    var name: String?
    var items: [OperationItem] = []
    
    enum Keys: String {
        case name
        case items = "item"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        name <- map.attributes[Keys.name.rawValue]
        items <- map[Keys.items.rawValue]
    }
}

class OperationItem: XMLMappable, SelectItemProtocol {
    var nodeName: String!
    
    var id: String?
    var name: String?
    var type: String?
    var operationType: String?
    
    enum Keys: String {
        case id, name, type
        case operationType = "OperationType"
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        id <- map.attributes[Keys.id.rawValue]
        name <- map.attributes[Keys.name.rawValue]
        type <- map.attributes[Keys.type.rawValue]
        operationType <- map.attributes[Keys.operationType.rawValue]
    }
    
    init(id: String, name: String, type: String) {
        self.id = id
        self.name = name
        self.type = type
    }
    
    // SelectItemProtocol
    func getID() -> String {
        return id ?? ""
    }
    
    func getTitle() -> String {
        return name ?? ""
    }
}
