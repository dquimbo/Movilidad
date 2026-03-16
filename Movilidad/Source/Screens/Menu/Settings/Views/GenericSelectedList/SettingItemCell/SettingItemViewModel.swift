//
//  SettingItemViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 9/2/22.
//

class SettingItemViewModel {
    
    // Properties
    private var item: SelectItemProtocol
    private var isLastCell: Bool
    private var isFirstCell: Bool
    private var isSelected: Bool
    
    init(item: SelectItemProtocol, isFirstCell: Bool, isLastCell: Bool, isSelected: Bool) {
        self.item = item
        self.isFirstCell = isFirstCell
        self.isLastCell = isLastCell
        self.isSelected = isSelected
    }
    
    // Public Properties
    var title: String? {
        return item.getTitle()
    }
    
    var isFirstCellItem: Bool {
        return isFirstCell
    }
    
    var isLastCellItem: Bool {
        return isLastCell
    }
    
    var isCellItemSelected: Bool {
        return isSelected
    }
}
