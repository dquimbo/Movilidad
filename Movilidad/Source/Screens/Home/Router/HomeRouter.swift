//
//  HomeRouter.swift
//  MovilidadUK
//
//  Created by Diego Quimbo on 4/1/22.
//


import UIKit

struct HomeRouter: Router {
    enum Route {
        case back
        case appSwitcher(appsSwitcher: [AppSwitcher])
        case dismissModal
        case serviceErrorDetail
    }

    // MARK: - Properties
    unowned var controller: HomeViewController

    // MARK: - Life Cycle
    init(controller: HomeViewController) {
        self.controller = controller
    }

    // MARK: - Functions
    func route(route: Route) {
        switch route {
        case .back:
            controller.navigationController?.dismiss(animated: true, completion: nil)
        case .appSwitcher(let appsSwitcher):
            let controllerAppSwitcher = AppSwitcherBuilder.build(appsSwitcher: appsSwitcher)
            controllerAppSwitcher.modalPresentationStyle = .fullScreen
            controllerAppSwitcher.delegate = controller
            controller.present(controllerAppSwitcher, animated: true, completion: nil)
        case .dismissModal:
            controller.dismiss(animated: true, completion: nil)
        case .serviceErrorDetail:
            let loginError = controller.vM.serviceError
            let loginErrorDetail = ServiceErrorDetailBuilder.build(serviceError: loginError)
            controller.present(loginErrorDetail, animated: true, completion: nil)
        }
    }
}
