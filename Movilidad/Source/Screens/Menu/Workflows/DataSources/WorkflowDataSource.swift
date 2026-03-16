//
//  WorkflowDataSource.swift
//  Movilidad
//
//  Created by Diego Quimbo on 3/2/22.
//

import UIKit

class WorkflowDataSource: NSObject, UITableViewDataSource {
    // MARK: - Properties
    unowned var controller: MenuWorkflowViewController

    // MARK: - Initializer
    init(controller: MenuWorkflowViewController) {
        self.controller = controller
    }

    // MARK: - DataSource Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return controller.vM.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.vM.getNumberOfRowsInSections(sectionIndex: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseIdentifier,
                                                       for: indexPath) as? MenuItemCell else {
            return UITableViewCell()
        }

        let operationItem = controller.vM.getTransactionItem(indexPath: indexPath)
        let isLastRow = controller.vM.isLastRowInSection(indexPath: indexPath)
        
        let cellViewModel = MenuItemCellViewModel(operationItem: operationItem, tabType: .Workflows, isLastCell: isLastRow)
        cell.configure(viewModel: cellViewModel)

        return cell
    }
}
