//
//  ControlContainerViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 24/3/22.
//

import UIKit

final class ControlContainerViewModel {
    let formControl: FormControlContainer
    
    init(formControl: FormControlContainer) {
        self.formControl = formControl
    }
    
    // MARK: - Vars
    var title: String {
        return formControl.title
    }
    
    var type: FormControlContainerType {
        return formControl.type
    }
    
    // MARK: - Public Functions
    func buildControl(controlItem: FormControlItem, delegate: ControlButtonViewDelegate) -> UIView? {
        switch controlItem.type {
        case .Textbox:
            return ControlTextboxView(textboxItem: controlItem)
        case .Button:
            return ControlButtonView(buttonItem: controlItem, delegate: delegate)
        case .Datebox:
            return ControlDateView(dateItem: controlItem)
        case .Checkbox:
            return ControlCheckbox(checkboxItem: controlItem)
        case .Grid:
            return ControlGridView(gridItem: controlItem)
        default:
            return nil
        }
    }
}
