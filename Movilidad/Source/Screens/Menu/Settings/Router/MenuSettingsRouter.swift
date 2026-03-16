//
//  MenuSettingsRouter.swift
//  Movilidad
//
//  Created by Diego Quimbo on 7/2/22.
//

import UIKit

struct MenuSettingsRouter: Router {
    enum Route {
        case navigatorWeb
    }

    // MARK: - Properties
    unowned var controller: MenuSettingsViewController

    // MARK: - Life Cycle
    init(controller: MenuSettingsViewController) {
        self.controller = controller
    }

    // MARK: - Functions
    func route(route: Route) {
        switch route {
        case .navigatorWeb:
            let navigatorWebVC = NavigatorWebBuilder.build()
            navigatorWebVC.modalPresentationStyle = .fullScreen
            controller.present(navigatorWebVC, animated: true, completion: nil)
        }
    }
}
