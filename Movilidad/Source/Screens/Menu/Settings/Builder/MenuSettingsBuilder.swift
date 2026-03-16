//
//  MenuSettingsBuilder.swift
//  Movilidad
//
//  Created by Diego Quimbo on 7/2/22.
//

import UIKit

struct MenuSettingsBuilder {
    static func build() -> UINavigationController {
        let viewModel: MenuSettingsViewModel = .init()
        let controller: MenuSettingsViewController = .init(viewModel: viewModel)
        let navController: UINavigationController = .init(rootViewController: controller)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .fullScreen
        return navController
    }
}
