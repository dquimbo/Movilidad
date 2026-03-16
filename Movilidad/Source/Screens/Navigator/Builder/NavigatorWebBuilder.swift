//
//  NavigatorWebBuilder.swift
//  Movilidad
//
//  Created by Diego Quimbo on 11/9/23.
//

struct NavigatorWebBuilder {
    static func build() -> NavigatorWebViewController {
        let viewModel: NavigatorWebViewModel = .init()
        let navigatorController: NavigatorWebViewController = .init(viewModel: viewModel)
        return navigatorController
    }
}
