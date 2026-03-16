//
//  MenuSettingsViewController.swift
//  Movilidad
//
//  Created by Diego Quimbo on 7/2/22.
//

import UIKit

class MenuSettingsViewController: UIViewController, NibLoadable {
    // MARK: - IBOutlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var initalsLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var redirectTransactionsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var initialProfileLabel: UILabel!
    @IBOutlet weak var initialOperationLabel: UILabel!
    @IBOutlet weak var transactionsRedirectView: UIView!
    @IBOutlet weak var transactionRedirectLabel: UILabel!
    
    // Public Properties
    let vM: MenuSettingsViewModel
    var router: MenuSettingsRouter?

    // MARK: - Life Cycle
    required init(viewModel: MenuSettingsViewModel) {
        self.vM = viewModel
        super.init(nibName: MenuSettingsViewController.nibName, bundle: MenuSettingsViewController.bundle)
        
        self.router = .init(controller: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDataInView()
    }
    
    // MARK: - IBActions
    @IBAction func pressProfile(_ sender: Any) {
        let profileListVC = GenericItemsSettingsViewController(actionType: .profileSelected)
        navigationController?.pushViewController(profileListVC, animated: true)
    }
    
    @IBAction func pressRedirectTransaction(_ sender: Any) {
        let profileListVC = GenericItemsSettingsViewController(actionType: .redirectTransactionSelected)
        navigationController?.pushViewController(profileListVC, animated: true)
    }
    
    @IBAction func signoutPressed(_ sender: Any) {
        signOut()
    }
    
    @IBAction func initialProfilePressed(_ sender: Any) {
        let profileListVC = GenericItemsSettingsViewController(actionType: .initialProfileSelected)
        navigationController?.pushViewController(profileListVC, animated: true)
    }
    
    @IBAction func initialOperationPressed(_ sender: Any) {
        let profileListVC = GenericItemsSettingsViewController(actionType: .initialOperationSelected)
        navigationController?.pushViewController(profileListVC, animated: true)
    }
    
    @IBAction func metroDesktopPressed(_ sender: Any) {
        let profileListVC = GenericItemsSettingsViewController(actionType: .metroDesktopSelected)
        navigationController?.pushViewController(profileListVC, animated: true)
    }
    
    @IBAction func initInDesktopPressed(_ sender: Any) {
        vM.setInitInMetroDesktop(initMetroDesktop: !vM.initInMetroDesktop)
        
        loadDataInView()
    }
    
    @IBAction func navigatorPressed(_ sender: Any) {
        router?.route(route: .navigatorWeb)
    }
    
    // MARK: - Public Funcions
}

// MARK: - Private Functions
private extension MenuSettingsViewController {
    func loadDataInView() {
        usernameLabel.text = vM.username
        initalsLabel.text = vM.initials
        profileLabel.text = vM.titleProfile
        redirectTransactionsLabel.text = vM.redirectTransaction
        languageLabel.text = vM.language
        serverLabel.text = vM.server
        versionLabel.text = vM.version
        buildLabel.text = vM.build
        initialProfileLabel.text = vM.initialProfile
        initialOperationLabel.text = vM.initialOperation
        
        transactionsRedirectView.isHidden = !vM.showTransactionRedirect
        transactionRedirectLabel.text = vM.transactionRedirectSelected
    }
    
    func signOut() {
        NotificationCenter.default.post(name: .logout, object: nil, userInfo: nil)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(profileSelectedHasChanged(_:)), name: .profileSelectedHasChanged, object: nil)
    }
    
    @objc func profileSelectedHasChanged(_ notification: NSNotification) {
        loadDataInView()
    }
}
