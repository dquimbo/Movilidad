//
//  NetworkToolBuilder.swift
//  Movilidad
//
//  Created by Diego Quimbo on 4/5/23.
//

struct NetworkToolBuilder {
    static func build() -> NetworkToolViewController {
        let viewModel: NetworkToolViewModel = .init()
        let networkToolController: NetworkToolViewController = .init(viewModel: viewModel)
        return networkToolController
    }
}
