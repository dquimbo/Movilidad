//
//  FavoriteAppsTableDataSource.swift
//  Movilidad
//
//  Created by Diego Quimbo on 14/3/22.
//

import UIKit

class FavoriteAppsTableDataSource: NSObject, UITableViewDataSource {
    // MARK: - Properties
    unowned var controller: WelcomeView

    // MARK: - Initializer
    init(controller: WelcomeView) {
        self.controller = controller
    }

    // MARK: - DataSource Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.vM.getNumberOfFavoriteOperations()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteAppCell.reuseIdentifier,
                                                       for: indexPath) as? FavoriteAppCell else {
            return UITableViewCell()
        }
        
        
        let cellViewModel = FavoriteAppCellViewModel(operation: controller.vM.getFavoriteOperationByIndex(index: indexPath.row))
        cell.configure(viewModel: cellViewModel)

        return cell
    }
}
