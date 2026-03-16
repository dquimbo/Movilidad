//
//  WorkflowTableDelegate.swift
//  Movilidad
//
//  Created by Diego Quimbo on 3/2/22.
//

import UIKit

class WorkflowTableDelegate: NSObject, UITableViewDelegate  {
    
    // MARK: - Properties
    unowned let controller: MenuWorkflowViewController

    init(controller: MenuWorkflowViewController) {
        self.controller = controller
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView: MenuHeaderCell = MenuHeaderCell.loadFromNib() as? MenuHeaderCell else {
            return nil
        }

        let title = controller.vM.getSectionTitle(section: section)
        headerView.configure(viewModel: MenuHeaderCellViewModel(title: title))

        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = controller.vM.getTransactionItem(indexPath: indexPath)
        controller.delegate?.workflowItemHasSelected(operation: item)
    }
}
