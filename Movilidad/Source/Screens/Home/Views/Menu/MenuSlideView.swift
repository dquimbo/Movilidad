//
//  MenuSlideView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 28/1/22.
//

import UIKit

protocol MenuSlideViewDelegate: AnyObject {
    func transactionItemHasSelected(operation: OperationItem)
    func appItemHasSelected(operation: OperationItem)
    func workflowItemHasSelected(operation: OperationItem)
}

class MenuSlideView: NibLoadingView {
    
    // IBOutlets
    @IBOutlet weak var tabbedPageView: TabbedPageView!
    
    // Properties
    weak var delegate: MenuSlideViewDelegate?
    private let transactionsVC = MenuTransactionBuilder.build()
    private let indicatorsVC = MenuIndicatorBuilder.build()
    private let workflowsVC = MenuWorkflowBuilder.build()
    private let appsVC = MenuAppBuilder.build()
    private let settingsVC = MenuSettingsBuilder.build()
    
    // MARK: - Lifecycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView() {
        transactionsVC.delegate = self
        workflowsVC.delegate = self
        appsVC.delegate = self
        
        let tabs = [
            Tab(contentSource: .viewController(transactionsVC), type: .Transactions),
            Tab(contentSource: .viewController(indicatorsVC), type: .Indicators),
            Tab(contentSource: .viewController(workflowsVC), type: .Workflows),
            Tab(contentSource: .viewController(appsVC), type: .Apps),
            Tab(contentSource: .viewController(settingsVC), type: .Settings)
        ]
        
        tabbedPageView.setTabs(tabs: tabs)
        
        tabbedPageView.reloadData()
    }
    
    func reloadLayout() {
        tabbedPageView.reloadLayout()
    }
    
    func reloadData() {
        transactionsVC.reloadData()
        indicatorsVC.reloadData()
        workflowsVC.reloadData()
        appsVC.reloadData()
    }
}

// MARK: - Menu Tabs Delegates
extension MenuSlideView: MenuTransactionViewControllerDelegate,
                         MenuWorkflowViewControllerDelegate,
                         MenuAppViewControllerDelegate {
    
    // MenuTransactionViewControllerDelegate
    func transactionItemHasSelected(operation: OperationItem) {
        delegate?.transactionItemHasSelected(operation: operation)
    }
    
    // MenuWorkflowViewControllerDelegate
    func workflowItemHasSelected(operation: OperationItem) {
        delegate?.workflowItemHasSelected(operation: operation)
    }
    
    // MenuAppViewControllerDelegate
    func appItemHasSelected(operation: OperationItem) {
        delegate?.appItemHasSelected(operation: operation)
    }
}

