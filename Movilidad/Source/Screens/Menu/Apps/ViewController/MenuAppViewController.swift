//
//  MenuAppViewController.swift
//  Movilidad
//
//  Created by Diego Quimbo on 2/2/22.
//

import UIKit

protocol MenuAppViewControllerDelegate: AnyObject {
    func appItemHasSelected(operation: OperationItem)
}

class MenuAppViewController: UIViewController, NibLoadable {
    // MARK: - IBOutlets
    @IBOutlet weak var appsTableView: UITableView! {
        didSet {
            appsTableView.dataSource = appsDataSource
            appsTableView.delegate = appsDelegate
            appsTableView.separatorStyle = .none
            appsTableView.register(MenuItemCell.nib,
                               forCellReuseIdentifier: MenuItemCell.reuseIdentifier)
        }
    }
    
    // Public Properties
    let vM: MenuAppViewModel
    var router: MenuAppRouter?
    weak var delegate: MenuAppViewControllerDelegate?
    
    // Private Properties
    private var appsDataSource: AppsTableDataSource?
    private var appsDelegate: AppsTableDelegate?

    
    // MARK: - Life Cycle
    required init(viewModel: MenuAppViewModel) {
        self.vM = viewModel
        super.init(nibName: MenuAppViewController.nibName, bundle: MenuAppViewController.bundle)
        
        self.router = .init(controller: self)
        self.appsDataSource = .init(controller: self)
        self.appsDelegate = .init(controller: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vM.builMenuApps()
        
        appsTableView.reloadData()
    }
    
    func reloadData() {
        vM.builMenuApps()
        
        appsTableView?.reloadData()
    }
}
