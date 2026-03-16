//
//  NetworkToolRouter.swift
//  Movilidad
//
//  Created by Diego Quimbo on 4/5/23.
//

struct NetworkToolRouter: Router {
    enum Route {
        case back
    }
    
    // MARK: - Properties
    unowned var controller: NetworkToolViewController

    // MARK: - Life Cycle
    init(controller: NetworkToolViewController) {
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
