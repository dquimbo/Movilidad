//
//  LoginErrorDetailRouter.swift
//  Movilidad
//
//  Created by Diego Quimbo on 24/1/22.
//

import UIKit

struct ServiceErrorDetailRouter: Router {
    enum Route {
        case back
        case share
    }

    // MARK: - Properties
    unowned var controller: ServiceErrorDetailViewController

    // MARK: - Life Cycle
    init(controller: ServiceErrorDetailViewController) {
        self.controller = controller
    }

    // MARK: - Functions
    func route(route: Route) {
        switch route {
        case .back:
            controller.dismiss(animated: true, completion: nil)
        case .share:
            let items = [controller.vM.errorDescription]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            ac.popoverPresentationController?.sourceView = controller.view
            controller.present(ac, animated: true)
        }
    }
}
