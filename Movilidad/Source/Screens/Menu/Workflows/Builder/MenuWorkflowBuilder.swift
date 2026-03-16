//
//  MenuWorkflowBuilder.swift
//  Movilidad
//
//  Created by Diego Quimbo on 3/2/22.
//

import UIKit

struct MenuWorkflowBuilder {
    static func build() -> MenuWorkflowViewController {
        let viewModel: MenuWorkflowViewModel = .init()
        let controller: MenuWorkflowViewController = .init(viewModel: viewModel)
        return controller
    }
}
