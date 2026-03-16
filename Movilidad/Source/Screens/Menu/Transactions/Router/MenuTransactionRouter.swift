//
//  MenuTransactionRouter.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/2/22.
//

import UIKit

struct MenuTransactionRouter: Router {
    enum Route {
    }

    // MARK: - Properties
    unowned var controller: MenuTransactionViewController

    // MARK: - Life Cycle
    init(controller: MenuTransactionViewController) {
        self.controller = controller
    }

    // MARK: - Functions
    func route(route: Route) {
    }
}
