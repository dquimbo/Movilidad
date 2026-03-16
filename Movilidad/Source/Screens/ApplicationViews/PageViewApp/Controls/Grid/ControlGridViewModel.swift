//
//  ControlGridViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 8/6/22.
//

final class ControlGridViewModel {
    let gridItem: FormControlItem
    
    init(gridItem: FormControlItem) {
        self.gridItem = gridItem
    }
    
    var title: String {
        return gridItem.text
    }
    
    var textboxValue: String {
        return gridItem.date
    }
}

