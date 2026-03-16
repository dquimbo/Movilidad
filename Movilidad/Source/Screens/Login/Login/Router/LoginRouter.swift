//
//  LoginRouter.swift
//  DemoMovilidad-UK
//
//  Created by Diego Quimbo on 4/1/22.
//

import UIKit

struct LoginRouter: Router {
    enum Route {
        case home
        case loginErrorDetail
        case networkTool
    }

    // MARK: - Properties
    unowned var controller: LoginViewController

    // MARK: - Life Cycle
    init(controller: LoginViewController) {
        self.controller = controller
    }

    // MARK: - Functions
    func route(route: Route) {
        switch route {
        case .home:
            let homeController = HomeBuilder.build()
            controller.present(homeController, animated: true, completion: nil)
        case .loginErrorDetail:
            let loginError = controller.vM.loginError
            let loginErrorDetail = ServiceErrorDetailBuilder.build(serviceError: loginError)
            controller.present(loginErrorDetail, animated: true, completion: nil)
        case .networkTool:
            let networkToolVC = NetworkToolBuilder.build()
            networkToolVC.modalPresentationStyle = .fullScreen
            controller.present(networkToolVC, animated: true, completion: nil)
        }
    }
}
