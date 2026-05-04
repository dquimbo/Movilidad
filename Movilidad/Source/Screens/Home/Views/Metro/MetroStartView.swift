//
//  MetroStartView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 16/6/23.
//

import UIKit

protocol MetroStartViewDelegate: AnyObject {
    func tileItemHasSelected(operation: OperationWeb)
}

class MetroStartView: NibLoadingView {
    
    weak var delegate: MetroStartViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    @IBAction func desktopPressed(_ sender: Any) {
        let guid = SettingsHandler.shared.metroDesktopSelectedGuid
        
        guard !guid.isEmpty else {
            showAlert(title: L10n.General.Error.title, message: L10n.Metro.Desktop.Unselected.tile)
            return
        }
        
        let metroDesktopView = MetroDesktopView(guid: guid, frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), delegate: self)

        addSubview(metroDesktopView)
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        let metroSearchView = MetroSearchView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), delegate: self)

        addSubview(metroSearchView)
    }
}

// MARK: - Internal Methods
extension MetroStartView {
    func showMetroDesktopSelected() {
        let guid = SettingsHandler.shared.metroDesktopSelectedGuid
        guard !guid.isEmpty else {
            print("Enter to showMetroDesktopSelected, but no guid found")
            return 
        }

        let metroDesktopView = MetroDesktopView(guid: guid, frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), delegate: self)
        metroDesktopView.alpha = 0
        addSubview(metroDesktopView)

        UIView.animate(withDuration: 0.3) {
            metroDesktopView.alpha = 1
        }
    }
}

// MARK: - MetroDesktopViewDelegate
extension MetroStartView: MetroDesktopViewDelegate {
    func tileItemHasSelected(operation: OperationWeb) {
        delegate?.tileItemHasSelected(operation: operation)
    }
}

// MARK: - MetroSearchViewDelegate
extension MetroStartView: MetroSearchViewDelegate {
    func tileSearchHasSelected(guid: String) {
        let metroDesktopView = MetroDesktopView(guid: guid, frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), delegate: self)
        addSubview(metroDesktopView)
    }
}
