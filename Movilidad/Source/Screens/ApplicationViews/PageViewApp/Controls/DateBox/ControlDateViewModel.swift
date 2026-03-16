//
//  ControlDateView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 29/3/22.
//

final class ControlDateViewModel {
    let dateItem: FormControlItem
    
    init(dateItem: FormControlItem) {
        self.dateItem = dateItem
    }
    
    var title: String {
        return dateItem.text
    }
    
    var textboxValue: String {
        return dateItem.date
    }
}
