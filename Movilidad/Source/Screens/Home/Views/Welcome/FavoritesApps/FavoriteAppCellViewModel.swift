//
//  FavoriteAppCellViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 14/3/22.
//

import UIKit

class FavoriteAppCellViewModel {
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
