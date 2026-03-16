//
//  MenuTransactionBuilder.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/2/22.
//

import UIKit

struct MenuTransactionBuilder {
    static func build() -> MenuTransactionViewController {
        let viewModel: MenuTransactionViewModel = .init()
        let controller: MenuTransactionViewController = .init(viewModel: viewModel)
        return controller
    }
}
