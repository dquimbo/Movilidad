//
//  MenuAppRouter.swift
//  Movilidad
//
//  Created by Diego Quimbo on 2/2/22.
//

import UIKit

struct MenuAppRouter: Router {
    enum Route {
    }

    // MARK: - Properties
    unowned var controller: MenuAppViewController

    // MARK: - Life Cycle
    init(controller: MenuAppViewController) {
        self.controller = controller
    }

    // MARK: - Functions
    func route(route: Route) {
    }
}
