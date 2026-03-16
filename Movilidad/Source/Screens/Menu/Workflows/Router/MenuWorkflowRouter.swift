//
//  MenuWorkflowRouter.swift
//  Movilidad
//
//  Created by Diego Quimbo on 3/2/22.
//

import UIKit

struct MenuWorkflowRouter: Router {
    enum Route {
    }

    // MARK: - Properties
    unowned var controller: MenuWorkflowViewController

    // MARK: - Life Cycle
    init(controller: MenuWorkflowViewController) {
        self.controller = controller
    }

    // MARK: - Functions
    func route(route: Route) {
    }
}
