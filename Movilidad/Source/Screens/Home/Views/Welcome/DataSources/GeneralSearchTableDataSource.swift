//
//  GeneralSearchTableDataSource.swift
//  Movilidad
//
//  Created by Diego Quimbo on 23/5/22.
//

import UIKit

class GeneralSearchTableDataSource: NSObject, UITableViewDataSource {
    // MARK: - Properties
    unowned var controller: WelcomeView

    // MARK: - Initializer
    init(controller: WelcomeView) {
        self.controller = controller
    }

    // MARK: - DataSource Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.vM.getNumberOfRowsInSearchTableView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralSearchCell.reuseIdentifier,
                                                       for: indexPath) as? GeneralSearchCell else {
            return UITableViewCell()
        }
        
        let operationItem = controller.vM.getMenuItem(row: indexPath.row)
        
        let cellViewModel = GeneralSearchCellViewModel(operation: operationItem)
        cell.configure(viewModel: cellViewModel)

        return cell
    }
}
