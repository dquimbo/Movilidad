//
//  MenuIndicatorBuilder.swift
//  Movilidad
//
//  Created by Diego Quimbo on 3/2/22.
//

import UIKit

struct MenuIndicatorBuilder {
    static func build() -> MenuIndicatorViewController {
        let viewModel: MenuIndicatorViewModel = .init()
        let controller: MenuIndicatorViewController = .init(viewModel: viewModel)
        return controller
    }
}
