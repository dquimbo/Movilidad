//
//  Tile.swift
//  Movilidad
//
//  Created by Diego Quimbo on 10/10/23.
//

import XMLMapper

class TileControls: XMLMappable {
    var nodeName: String!
    
    var tiles: [Tile] = []
    
    enum Keys: String {
        case tiles = "controls.tile"
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        tiles <- map[Keys.tiles.rawValue]
    }
}


class Tile: XMLMappable {
    var nodeName: String!
    
    var title: String?
    var previewString: String?
    var navigationString: String?
    
    enum Keys: String {
        case title
        case previewString
        case navigationString
    }
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        title <- map.attributes[Keys.title.rawValue]
        previewString <- map.attributes[Keys.previewString.rawValue]
        navigationString <- map.attributes[Keys.navigationString.rawValue]
    }
}
