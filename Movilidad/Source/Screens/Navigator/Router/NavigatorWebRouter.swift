//
//  NavigatorWebRouter.swift
//  Movilidad
//
//  Created by Diego Quimbo on 11/9/23.
//

struct NavigatorWebRouter: Router {
    enum Route {
        case back
    }
    
    // MARK: - Properties
    unowned var controller: NavigatorWebViewController

    // MARK: - Life Cycle
    init(controller: NavigatorWebViewController) {
        self.controller = controller
    }

    // MARK: - Functions
    func route(route: Route) {
        switch route {
        case .back:
            controller.dismiss(animated: true)
        }
    }
}
