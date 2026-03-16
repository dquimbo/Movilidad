//
//  GeneralSearchTableDelegate.swift
//  Movilidad
//
//  Created by Diego Quimbo on 26/5/22.
//

import UIKit

class GeneralSearchTableDelegate: NSObject, UITableViewDelegate  {
    
    // MARK: - Properties
    unowned let controller: WelcomeView

    init(controller: WelcomeView) {
        self.controller = controller
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let operation = controller.vM.getMenuItem(row: indexPath.row)
        controller.delegate?.searchedOperationHasSelected(operation: operation)
    }
}

