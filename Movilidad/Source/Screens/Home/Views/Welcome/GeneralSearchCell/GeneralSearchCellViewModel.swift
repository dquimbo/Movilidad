//
//  GeneralSearchCellViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 23/5/22.
//

import UIKit

class GeneralSearchCellViewModel {
    // MARK: - Properties
    var operation: OperationItem
    
    // MARK: - Initializer
    init(operation: OperationItem) {
        self.operation = operation
    }
    
    // MARK: - Properties
    var title: String? {
        return operation.name
    }
}
