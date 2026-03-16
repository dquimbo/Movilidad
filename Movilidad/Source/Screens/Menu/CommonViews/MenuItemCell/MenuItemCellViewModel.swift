//
//  TransactionCellViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/2/22.
//

import UIKit

class MenuItemCellViewModel {
    // Properties
    private var operationItem: OperationItem
    private var isLastCell: Bool
    private var type: MenuTabType

    init(operationItem: OperationItem, tabType: MenuTabType, isLastCell: Bool) {
        self.operationItem = operationItem
        self.type = tabType
        self.isLastCell = isLastCell
    }
    
    // Public Properties
    var title: String? {
        return operationItem.name
    }
    
    var icon: UIImage {
        return type.iconItem
    }
    
    var isLastCellItem: Bool {
        return isLastCell
    }
}

