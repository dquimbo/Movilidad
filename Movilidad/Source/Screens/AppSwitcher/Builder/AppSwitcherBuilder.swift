//
//  AppSwitcherBuilder.swift
//  Movilidad
//
//  Created by Diego Quimbo on 2/3/22.
//

import UIKit

struct AppSwitcherBuilder {
    static func build(appsSwitcher: [AppSwitcher]) -> AppSwitcherViewController {
        let viewModel: AppSwitcherViewModel = .init(appsSwitcher: appsSwitcher)
        let controller: AppSwitcherViewController = .init(viewModel: viewModel)
        return controller
    }
}
