//
//  LoginSettingsView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 13/1/22.
//

import UIKit
//import DropDown

protocol LoginSettingsViewDelegate: AnyObject {
    func cancelPressed()
    func addServerPressed()
    func removeServerPressed(url: String)
    func networkToolPressed()
}

class LoginSettingsView: NibLoadingView {
    
    // IBOutlets
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var serverOptionsContentView: UIView!
    @IBOutlet weak var serverOptionLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    // Properties
    weak var delegate: LoginSettingsViewDelegate?
    
    let serverOptionsDropDown = DropDown()
    
    // MARK: - Lifecycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Functions
    func setupView(delegate: LoginSettingsViewDelegate) {
        self.delegate = delegate
        headerView.roundCorners(radius: 5.0, corners: [.topLeft, .topRight])
        
        appVersionLabel.text = SettingsHandler.shared.appInfo.version
        buildLabel.text = SettingsHandler.shared.appInfo.build
        languageLabel.text = SettingsHandler.shared.language
        
        setupServerOptionsDropDown()
    }
    
    // MARK: - IBActions
    @IBAction func cancelPressed(_ sender: Any) {
        delegate?.cancelPressed()
    }
    
    @IBAction func chooseServerOptions(_ sender: Any) {
        serverOptionsDropDown.show()
    }
    
    @IBAction func addServerPressed(_ sender: Any) {
        delegate?.addServerPressed()
    }
    
    @IBAction func networkTools(_ sender: Any) {
        delegate?.networkToolPressed()
    }
    
    // MARK: - Public Functions
    func refreshServerList() {
        serverOptionsDropDown.dataSource = SettingsHandler.shared.servers
        serverOptionLabel.text = SettingsHandler.shared.serverSelected
        serverOptionsDropDown.reloadAllComponents()
    }
}

// MARK: - Private Functions
private extension LoginSettingsView {
    func setupServerOptionsDropDown() {
        // The view to which the drop down will appear on
        serverOptionsDropDown.anchorView = serverOptionsContentView
        
        // Show DropDown below the anchor view
        serverOptionsDropDown.direction = .bottom
        serverOptionsDropDown.bottomOffset = CGPoint(x: 0, y: serverOptionsContentView.bounds.height)
        
        // DataSource
        serverOptionsDropDown.dataSource = SettingsHandler.shared.servers
        serverOptionLabel.text = SettingsHandler.shared.serverSelected
        
        serverOptionsDropDown.cellNib = UINib(nibName: "ServerOptionCell", bundle: nil)
        serverOptionsDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? ServerOptionCell else { return }
            
            // Setup your custom UI components
            cell.delegate = self
            cell.indexItem = index
        }
        
        // Action triggered on selection
        serverOptionsDropDown.selectionAction = { [weak self] (index, item) in
            self?.serverOptionLabel.text = item
            SettingsHandler.shared.saveServerSelected(url: item)
        }
    }
}

extension LoginSettingsView: ServerOptionCellDelegate {
    func removeOptionPressed(index: Int) {
        let url = SettingsHandler.shared.servers[index]
        delegate?.removeServerPressed(url: url)
        
        serverOptionsDropDown.hide()
    }
}
