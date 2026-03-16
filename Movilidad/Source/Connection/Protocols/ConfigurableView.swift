//
//  ConfigurableView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/2/22.
//

protocol ConfigurableView: NibLoadableView, Reusable {
    associatedtype ViewModel
    func configure(viewModel: ViewModel)
}
