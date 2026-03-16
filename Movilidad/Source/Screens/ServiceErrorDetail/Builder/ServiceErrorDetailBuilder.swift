//
//  LoginErrorDetailbuilder.swift
//  Movilidad
//
//  Created by Diego Quimbo on 24/1/22.
//

import UIKit

struct ServiceErrorDetailBuilder {
    static func build(serviceError: ServiceError?) -> UIViewController {
        let viewModel: ServiceErrorDetailViewModel = .init(loginError: serviceError)
        let controller: ServiceErrorDetailViewController = .init(viewModel: viewModel)
        return controller
    }
}
