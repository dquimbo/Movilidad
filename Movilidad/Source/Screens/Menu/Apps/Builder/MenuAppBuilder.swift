//
//  MenuAppBuilder.swift
//  Movilidad
//
//  Created by Diego Quimbo on 2/2/22.
//

import UIKit

struct MenuAppBuilder {
    static func build() -> MenuAppViewController {
        let viewModel: MenuAppViewModel = .init()
        let controller: MenuAppViewController = .init(viewModel: viewModel)
        return controller
    }
}
