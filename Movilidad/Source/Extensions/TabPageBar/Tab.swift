//
//  Tab.swift
//  Movilidad
//
//  Created by Diego Quimbo on 31/1/22.
//

import UIKit

public struct Tab {
    let id: String
    var source: TabSource
    var type: MenuTabType
    public var isSelected: Bool
    
    public init(contentSource: TabSource, type: MenuTabType) {
        self.id = UUID().uuidString
        self.source = contentSource
        self.isSelected = false
        self.type = type
    }
}
