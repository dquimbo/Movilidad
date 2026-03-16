//
//  AppsTableDelegate.swift
//  Movilidad
//
//  Created by Diego Quimbo on 2/2/22.
//

import UIKit

class AppsTableDelegate: NSObject, UITableViewDelegate  {
    
    // MARK: - Properties
    unowned let controller: MenuAppViewController

    init(controller: MenuAppViewController) {
        self.controller = controller
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView: MenuHeaderCell = MenuHeaderCell.loadFromNib() as? MenuHeaderCell else {
            return nil
        }

        headerView.configure(viewModel: MenuHeaderCellViewModel(title: L10n.Home.Menu.general))

        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = controller.vM.getTransactionItem(indexPath: indexPath)
        controller.delegate?.appItemHasSelected(operation: item)
    }
}
