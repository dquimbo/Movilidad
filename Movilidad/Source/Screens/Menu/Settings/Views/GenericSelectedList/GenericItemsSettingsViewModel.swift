//
//  GenericListItemsSettings.swift
//  Movilidad
//
//  Created by Diego Quimbo on 9/2/22.
//

import UIKit

enum GenericItemsSettingsActionType {
    case profileSelected
    case initialProfileSelected
    case initialOperationSelected
    case metroDesktopSelected
    case redirectTransactionSelected
}

class GenericItemsSettingsViewModel {
    let actionType: GenericItemsSettingsActionType
    
    init(action: GenericItemsSettingsActionType) {
        self.actionType = action
    }
    
    
    
    // Public Properties
    var items: [SelectItemProtocol] {
        switch actionType {
        case .profileSelected:
            return SessionManager.shared.profile?.profiles ?? []
        case .initialProfileSelected:
            var profiles = [ProfileItem(id: "-1", description: L10n.Settings.none)]
            profiles.append(contentsOf: SessionManager.shared.profile?.profiles ?? [])
            
            return profiles
        case .initialOperationSelected:
            var operations = [OperationItem(id: "-1", name: L10n.Settings.none)]
            operations.append(contentsOf: SessionManager.shared.getAllOperations() ?? [])
            
            return operations
        case .metroDesktopSelected:
            return SessionManager.shared.getAllTileOperations() ?? []
        case .redirectTransactionSelected:
            var transactionsRedirect = [TransactionRedirectSelectable(value: L10n.Settings.none)]
            transactionsRedirect.append(contentsOf: SessionManager.shared.profile?.transactionRedirectSelectableValues ?? [])

            return transactionsRedirect
        }
    }
    
    // Public Functions
    func isLastItem(row: Int) -> Bool {
        return row == items.count - 1
    }
    
    func isSelected(row: Int) -> Bool {
        // Check if item has been selected before
        let item = items[row]
        
        switch actionType {
        case .profileSelected:
            let selectedProfileGuid = SessionManager.shared.profile?.profileSelectedGuid ?? ""
            
            return item.getID() == selectedProfileGuid
        case .initialProfileSelected:
            let initialProfileGuid = SettingsHandler.shared.initialProfileSelectedGuid
            
            return item.getID() == initialProfileGuid
        case .initialOperationSelected:
            let initialOperationGuid = SettingsHandler.shared.initialOperationSelectedGuid
            
            return item.getID() == initialOperationGuid
        case .metroDesktopSelected:
            return false
        case .redirectTransactionSelected:
            let transactionRedirectSelected = SettingsHandler.shared.transactionRedirectSelected
            
            if transactionRedirectSelected.isEmpty && item.getID() == L10n.Settings.none {
                return true
            } else {
                return item.getID() == transactionRedirectSelected
            }
        }
    }
    
    func itemSelected(item: SelectItemProtocol) {
        switch actionType {
        case .profileSelected:
            SessionManager.shared.changeProfileSelected(profileItemID: item.getID())
            NotificationCenter.default.post(name: .profileSelectedHasChanged, object: nil, userInfo: nil)
        case .initialProfileSelected:
            SettingsHandler.shared.saveInitialProfile(profileItemID: item.getID())
        case .initialOperationSelected:
            SettingsHandler.shared.saveInitialOperation(operationItemID: item.getID())
        case .metroDesktopSelected:
            break
        case .redirectTransactionSelected:
            if item.getID() == L10n.Settings.none {
                SettingsHandler.shared.saveTransactionRedirect(transactionRedirect: "")
            } else {
                SettingsHandler.shared.saveTransactionRedirect(transactionRedirect: item.getID())
            }
        }
    }
}
