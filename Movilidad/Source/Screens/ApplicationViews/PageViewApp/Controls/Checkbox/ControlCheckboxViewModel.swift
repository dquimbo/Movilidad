//
//  ControlCheckboxViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 28/4/22.
//

import UIKit

final class ControlCheckboxViewModel {
    private let checkboxItem: FormControlItem
    private var checked: Bool = false
    
    init(checkboxItem: FormControlItem) {
        self.checkboxItem = checkboxItem
        self.checked = checkboxItem.checked.boolValue
    }
    
    var title: String {
        return checkboxItem.text
    }
    
    func getCheckboxImage() -> UIImage {
        return checked ? Asset.checkedCheckbox.image : Asset.uncheckedCheckbox.image
    }
    
    func switchCheck()  {
        checked.toggle()
    }
}
