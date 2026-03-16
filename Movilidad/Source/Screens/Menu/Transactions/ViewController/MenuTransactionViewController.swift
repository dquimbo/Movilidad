//
//  MenuTransactionViewController.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/2/22.
//

import UIKit

protocol MenuTransactionViewControllerDelegate: AnyObject {
    func transactionItemHasSelected(operation: OperationItem)
}

class MenuTransactionViewController: UIViewController, NibLoadable {
    // MARK: - IBOutlets
    @IBOutlet weak var transactionsTableView: UITableView! {
        didSet {
            transactionsTableView.dataSource = transactionsDataSource
            transactionsTableView.delegate = transactionsDelegate
            transactionsTableView.separatorStyle = .none
            transactionsTableView.register(MenuItemCell.nib,
                               forCellReuseIdentifier: MenuItemCell.reuseIdentifier)
        }
    }
    
    // Public Properties
    let vM: MenuTransactionViewModel
    var router: MenuTransactionRouter?
    weak var delegate: MenuTransactionViewControllerDelegate?
    
    // Private Properties
    private var transactionsDataSource: TransactionTableDataSource?
    private var transactionsDelegate: TransactionTableDelegate?
    
    // MARK: - Life Cycle
    required init(viewModel: MenuTransactionViewModel) {
        self.vM = viewModel
        super.init(nibName: MenuTransactionViewController.nibName, bundle: MenuTransactionViewController.bundle)
        
        self.router = .init(controller: self)
        self.transactionsDataSource = .init(controller: self)
        self.transactionsDelegate = .init(controller: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vM.builMenuTransactions()
        
        transactionsTableView.reloadData()
    }
    
    func reloadData() {
        vM.builMenuTransactions()
        
        transactionsTableView.reloadData()
    }
}
