//
//  MetroStartView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 16/6/23.
//

import Foundation

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
        guard let tilesOperations = SessionManager.shared.getAllTileOperations(),
        !tilesOperations.isEmpty,
        let guid = tilesOperations[0].id else {
            showAlert(title: L10n.General.Error.title, message: L10n.Metro.Desktop.Empty.tiles)
            return
        }
        
        let metroDesktopView = MetroDesktopView(guid: guid, frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), delegate: self)

        addSubview(metroDesktopView)
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        let metroSearchView = MetroSearchView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        addSubview(metroSearchView)
    }
}

// MARK: - MetroDesktopViewDelegate
extension MetroStartView: MetroDesktopViewDelegate {
    func tileItemHasSelected(operation: OperationWeb) {
        delegate?.tileItemHasSelected(operation: operation)
    }
}
