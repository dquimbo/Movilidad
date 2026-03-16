//
//  MenuAppViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 2/2/22.
//

import Foundation

final class MenuAppViewModel {
    
    var sectionItems: [SectionItem] = []
    
    // MARK: - Public Functions    
    func builMenuApps() {
        sectionItems.removeAll()
        let allSections = SessionManager.shared.menu?.sectionItems ?? []
        
        guard !allSections.isEmpty else { return }
        
        // Merged all sections in only one
        let mergedSection = allSections[0].copy()
        
        for index in 0..<allSections.count where index != 0 {
            let sectionContent = allSections[index].sectionContent
            
            mergedSection.sectionContent.append(contentsOf: sectionContent)
        }
        
        let mergedSectionCopy = mergedSection.copy()
        let allOperationItems = mergedSectionCopy.getAllMenuItemsForSection()
        
        // Filtered items and only get apps items
        mergedSectionCopy.filteredItems = allOperationItems.filter({ $0.type == ItemType.O.rawValue && $0.operationType == OperationType.Apps.rawValue })
        
        if !mergedSectionCopy.filteredItems.isEmpty {
            self.sectionItems.append(mergedSectionCopy)
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
}
