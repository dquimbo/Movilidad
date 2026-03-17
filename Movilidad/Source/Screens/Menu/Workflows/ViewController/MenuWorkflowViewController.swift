//
//  MenuWorkflowViewController.swift
//  Movilidad
//
//  Created by Diego Quimbo on 3/2/22.
//

import UIKit

protocol MenuWorkflowViewControllerDelegate: AnyObject {
    func workflowItemHasSelected(operation: OperationItem)
}

class MenuWorkflowViewController: UIViewController, NibLoadable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var workflowsTableView: UITableView! {
        didSet {
            workflowsTableView.dataSource = workflowTableDataSource
            workflowsTableView.delegate = workflowTableDelegate
            workflowsTableView.separatorStyle = .none
            workflowsTableView.register(MenuItemCell.nib,
                               forCellReuseIdentifier: MenuItemCell.reuseIdentifier)
        }
    }
    
    // Public Properties
    let vM: MenuWorkflowViewModel
    var router: MenuWorkflowRouter?
    weak var delegate: MenuWorkflowViewControllerDelegate?
    
    // Private Properties
    private var workflowTableDataSource: WorkflowDataSource?
    private var workflowTableDelegate: WorkflowTableDelegate?
    
    // MARK: - Life Cycle
    required init(viewModel: MenuWorkflowViewModel) {
        self.vM = viewModel
        super.init(nibName: MenuWorkflowViewController.nibName, bundle: MenuWorkflowViewController.bundle)
        
        self.router = .init(controller: self)
        self.workflowTableDataSource = .init(controller: self)
        self.workflowTableDelegate = .init(controller: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vM.builMenuWorkflows()
        
        workflowsTableView.reloadData()
    }
    
    func reloadData() {
        vM.builMenuWorkflows()
        
        workflowsTableView?.reloadData()
    }
}
