//
//  LoginBuilder.swift
//  DemoMovilidad-UK
//
//  Created by Diego Quimbo on 4/1/22.
//

struct LoginBuilder {
    static func build() -> LoginViewController {
        let viewModel: LoginViewModel = .init()
        let loginController: LoginViewController = .init(viewModel: viewModel)
        return loginController
    }
}
