//
//  TransactionTableDelegate.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/2/22.
//

import UIKit

class TransactionTableDelegate: NSObject, UITableViewDelegate  {
    
    // MARK: - Properties
    unowned let controller: MenuTransactionViewController

    init(controller: MenuTransactionViewController) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = controller.vM.getTransactionItem(indexPath: indexPath)
        controller.delegate?.transactionItemHasSelected(operation: item)
    }
}
