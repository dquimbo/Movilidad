//
//  ControlTextboxViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 25/3/22.
//

final class ControlTextboxViewModel {
    let textboxItem: FormControlItem
    
    init(textboxItem: FormControlItem) {
        self.textboxItem = textboxItem
    }
    
    var title: String {
        return textboxItem.tooltip
    }
    
    var textboxValue: String {
        return textboxItem.text
    }
    
    var readonly: Bool {
        return textboxItem.readonly.boolValue
    }
    
    var shouldShowBarcode: Bool {
        return textboxItem.barcode.boolValue
    }
}
