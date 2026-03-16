//
//  AppSwitcherRouter.swift
//  Movilidad
//
//  Created by Diego Quimbo on 2/3/22.
//

import UIKit

struct AppSwitcherRouter: Router {
    enum Route {
    }

    // MARK: - Properties
    unowned var controller: AppSwitcherViewController

    // MARK: - Life Cycle
    init(controller: AppSwitcherViewController) {
        self.controller = controller
    }

    // MARK: - Functions
    func route(route: Route) {
    }
}
