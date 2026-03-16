//
//  MenuIndicatorViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 3/2/22.
//

import Foundation

final class MenuIndicatorViewModel {
    
    var sectionItems: [SectionItem] = []
    
    // MARK: - Public Functions
    func builMenuTransactions() {
        let allSections = SessionManager.shared.menu?.sectionItems ?? []
        
        for section in allSections {
            let allOperationItems = getAllItemsForSection(sectionItem: section)
            
            // Filtered items and only get apps items
            section.filteredItems = allOperationItems.filter({ $0.type == ItemType.O.rawValue && $0.operationType == OperationType.Apps.rawValue })
            
            self.sectionItems.append(section)
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

// MARK: - Private Functions
private extension MenuIndicatorViewModel {
    func getAllItemsForSection(sectionItem: SectionItem) -> [OperationItem] {
        // Get all items associated to sections
        var items: [OperationItem] = []
        
        for sectionContent in sectionItem.sectionContent {
            items.append(contentsOf: sectionContent.items)
        }
        
        return items
    }
}
