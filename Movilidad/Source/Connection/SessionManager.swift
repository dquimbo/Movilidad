//
//  SessionManager.swift
//  Movilidad
//
//  Created by Diego Quimbo on 26/1/22.
//

import Foundation

class SessionManager {
    static let shared: SessionManager = {
        return SessionManager()
    }()

    // Public Properties
    var profile: Profile?
    var menu: Menu?
    
    // Privare Properties
    private var favoriteOperations: [OperationItem] {
        if let allOperations = menu?.getAllMenuItems() {
            let favoriteOperationsIds = UserDefaults.standard.object(forKey: NSUserDefaultsKeys.favoritesOperationsKey) as? [String] ?? []
            
            return allOperations.filter({ favoriteOperationsIds.contains($0.id ?? "") })
        }
        
        return []
    }
    
    // Public Functions
    func changeProfileSelected(profileItemID: String) {
        profile?.profileSelectedGuid = profileItemID
    }
    
    func handleFavoriteAction(operation: OperationItem) {
        var currentFavoriteOperations = favoriteOperations
        
        if favoriteOperationExist(operation: operation) {
            // Remove operation
            currentFavoriteOperations = currentFavoriteOperations.filter({$0.id != operation.id})
        } else {
            // Add operation
            currentFavoriteOperations.append(operation)
        }
        
        let operationsIDS = currentFavoriteOperations.map({ return $0.id })
        UserDefaults.standard.set(operationsIDS, forKey: NSUserDefaultsKeys.favoritesOperationsKey)
    }
    
    func operationIsInFavoriteList(operation: OperationItem?) -> Bool {
        guard let operationWrap = operation else { return false }
        return favoriteOperationExist(operation: operationWrap)
    }
    
    func getFavoriteOperations() -> [OperationItem] {
        return favoriteOperations
    }
    
    func getAllOperations() -> [OperationItem]? {
        return menu?.getAllMenuItems()
    }
    
    func getAllTileOperations() -> [OperationItem]? {
        guard let allOperationItems = menu?.getALLOperationItemsInNullableSections() else {
            return nil
        }
        
        return allOperationItems.filter({ $0.type == ItemType.O.rawValue && $0.operationType == OperationType.Tile.rawValue })
    }
}

private extension SessionManager {
    func favoriteOperationExist(operation: OperationItem) -> Bool {
        return favoriteOperations.contains(where: { $0.id == operation.id})
    }
}
