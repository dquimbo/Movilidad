//
//  ControlButtonViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 28/3/22.
//

final class ControlButtonViewModel {
    let buttonItem: FormControlItem
    
    // Private Properties
    private let operationService = ConnectionManager_Operation()
    
    init(buttonItem: FormControlItem) {
        self.buttonItem = buttonItem
    }
    
    var id: String {
        return buttonItem.id
    }
    
    var title: String {
        return buttonItem.text
    }
}
