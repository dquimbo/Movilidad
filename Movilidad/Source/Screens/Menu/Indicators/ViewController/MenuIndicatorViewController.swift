//
//  MenuIndicatorViewController.swift
//  Movilidad
//
//  Created by Diego Quimbo on 3/2/22.
//

import UIKit

class MenuIndicatorViewController: UIViewController, NibLoadable {
    
    // Public Properties
    let vM: MenuIndicatorViewModel
    var router: MenuIndicatorRouter?

    // MARK: - Life Cycle
    required init(viewModel: MenuIndicatorViewModel) {
        self.vM = viewModel
        super.init(nibName: MenuIndicatorViewController.nibName, bundle: MenuIndicatorViewController.bundle)
        
        self.router = .init(controller: self)
//        self.appsDataSource = .init(controller: self)
//        self.appsDelegate = .init(controller: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadData() {
    }
}
