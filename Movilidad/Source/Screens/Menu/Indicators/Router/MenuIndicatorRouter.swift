//
//  MenuIndicatorRouter.swift
//  Movilidad
//
//  Created by Diego Quimbo on 3/2/22.
//

import UIKit

struct MenuIndicatorRouter: Router {
    enum Route {
    }

    // MARK: - Properties
    unowned var controller: MenuIndicatorViewController

    // MARK: - Life Cycle
    init(controller: MenuIndicatorViewController) {
        self.controller = controller
    }

    // MARK: - Functions
    func route(route: Route) {
    }
}
