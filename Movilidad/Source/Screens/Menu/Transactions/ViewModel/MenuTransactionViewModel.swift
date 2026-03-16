//
//  MenuTransactionViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/2/22.
//

import Foundation

final class MenuTransactionViewModel {
    
    var sectionItems: [SectionItem] = []
    
    // MARK: - Public Functions
    func builMenuTransactions() {
        sectionItems.removeAll()
        
        let allSections = SessionManager.shared.menu?.sectionItems ?? []
        
        for section in allSections {
            let sectionCopy = section.copy()
            let allOperationItems = sectionCopy.getAllMenuItemsForSection()
            
            // Filtered items and only get transaction items
            section.filteredItems = allOperationItems.filter({ $0.type == ItemType.O.rawValue
                && $0.operationType != OperationType.Apps.rawValue
                && $0.operationType != OperationType.Tile.rawValue
                && $0.operationType != OperationType.Activities.rawValue })
            
            if !section.filteredItems.isEmpty {
                self.sectionItems.append(section)
            }
        }
    }
    
    func getNumberOfSections() -> Int {
        return sectionItems.count
    }
    
    func getNumberOfRowsInSections(sectionIndex: Int) -> Int {
        return sectionItems[sectionIndex].filteredItems.count
    }
    
    func getTransactionItem(indexPath: IndexPath) -> OperationItem {
        return sectionItems[indexPath.section].filteredItems[indexPath.row]
    }
    
    func isLastRowInSection(indexPath: IndexPath) -> Bool {
        let countItems = getNumberOfRowsInSections(sectionIndex: indexPath.section)
        return indexPath.row == countItems - 1
    }
    
    func getSectionTitle(section: Int) -> String {
        return sectionItems[section].name ?? ""
    }
}
