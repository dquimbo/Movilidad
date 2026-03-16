//
//  HomeBuilder.swift
//  MovilidadUK
//
//  Created by Diego Quimbo on 4/1/22.
//

import UIKit

struct HomeBuilder {
    static func build() -> UIViewController {
        let viewModel: HomeViewModel = .init()
        let controller: HomeViewController = .init(viewModel: viewModel)
        let navController: UINavigationController = .init(rootViewController: controller)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .fullScreen
        return navController
    }
}
