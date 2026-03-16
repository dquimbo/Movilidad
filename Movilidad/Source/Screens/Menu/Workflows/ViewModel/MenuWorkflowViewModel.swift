//
//  MenuWorkflowViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 3/2/22.
//

import Foundation

final class MenuWorkflowViewModel {
    
    var sectionItems: [SectionItem] = []
    
    // MARK: - Public Functions
    func builMenuWorkflows() {
        sectionItems.removeAll()
        
        let siteItemIntra = OperationItem(id: "Intra", name: "Intra", type: ItemType.O.rawValue)
        let siteSectionItem = SectionItem(name: "Sites", sectionContent: [], filteredItems: [siteItemIntra])
        sectionItems.append(siteSectionItem)
        
        let workflowItemNorth = OperationItem(id: "Norte", name: "Norte", type: ItemType.O.rawValue)
        let workflowItemSouth = OperationItem(id: "Sur", name: "Sur", type: ItemType.O.rawValue)
        let workflowDevelop = OperationItem(id: "Desarrollo", name: "Desarrollo", type: ItemType.O.rawValue)
        let workflowSectionItem = SectionItem(name: "Workflows", sectionContent: [], filteredItems: [workflowItemNorth, workflowItemSouth, workflowDevelop])
        sectionItems.append(workflowSectionItem)
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
