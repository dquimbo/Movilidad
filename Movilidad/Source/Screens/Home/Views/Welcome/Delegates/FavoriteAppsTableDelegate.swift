//
//  FavoriteAppsTableDelegate.swift
//  Movilidad
//
//  Created by Diego Quimbo on 25/3/22.
//

import UIKit

class FavoriteAppsTableDelegate: NSObject, UITableViewDelegate  {
    
    // MARK: - Properties
    unowned let controller: WelcomeView

    init(controller: WelcomeView) {
        self.controller = controller
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let operation = controller.vM.getFavoriteOperationByIndex(index: indexPath.row)
        controller.delegate?.favoriteOperationHasSelected(operation: operation)
    }
}
