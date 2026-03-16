//
//  OperationForm.swift
//  Movilidad
//
//  Created by Diego Quimbo on 23/3/22.
//

import XMLMapper

class OperationForm: XMLMappable {
    var nodeName: String!
    
    var context: FormContext?
    var viewState = ""
    var controls: [FormControlContainer] = []
    
    enum Keys: String {
        case context
        case viewState = "viewstate"
        case controls = "controls.control"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        context <- map[Keys.context.rawValue]
        viewState <- map[Keys.viewState.rawValue]
        controls <- map[Keys.controls.rawValue]
    }
}

class FormControlContainer: XMLMappable {
    var nodeName: String!
    
    var title: String = ""
    var type: FormControlContainerType = .Container
    var controls: [FormControlItem] = []
    var gridRows: [FormGridRowItem] = []
    
    enum Keys: String {
        case title
        case type
        case controls = "controls.control"
        case gridRows = "row"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        title <- map.attributes[Keys.title.rawValue]
        type <- map.attributes[Keys.type.rawValue]
        controls <- map[Keys.controls.rawValue]
        gridRows <- map[Keys.gridRows.rawValue]
    }
}

class FormControlItem: XMLMappable {
    var nodeName: String!
    
    var id: String = ""
    var tooltip: String = ""
    var type: FormControlType?
    var text: String = ""
    var readonly: String = ""
    var barcode: String = ""
    var date: String = ""
    var checked: String = ""
    
    enum Keys: String {
        case id
        case tooltip
        case type
        case text
        case readonly
        case barcode
        case date
        case checked
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        id <- map.attributes[Keys.id.rawValue]
        tooltip <- map.attributes[Keys.tooltip.rawValue]
        type <- map.attributes[Keys.type.rawValue]
        text <- map.attributes[Keys.text.rawValue]
        readonly <- map.attributes[Keys.readonly.rawValue]
        barcode <- map.attributes[Keys.barcode.rawValue]
        date <- map.attributes[Keys.date.rawValue]
        checked <- map.attributes[Keys.checked.rawValue]
    }
}

class FormGridRowItem: XMLMappable {
    var nodeName: String!
    
    var val0: String = ""
    var val1: String = ""
    
    enum Keys: String {
        case val0
        case val1
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        val0 <- map.attributes[Keys.val0.rawValue]
        val1 <- map.attributes[Keys.val1.rawValue]
    }
}

class FormContext: XMLMappable {
    var nodeName: String!
    
    var id: Int = 0
    var mergeContextInfo = ""
    var innerContext = ""
    var executionNode = ""
    
    enum Keys: String {
        case id
        case mergeContextInfo = "mergecontextinfo"
        case executionNode = "executionnode"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        id <- map.attributes[Keys.id.rawValue]
        mergeContextInfo <- map.attributes[Keys.mergeContextInfo.rawValue]
        innerContext <- map.innerText
        executionNode <- map.attributes[Keys.executionNode.rawValue]
    }
}
