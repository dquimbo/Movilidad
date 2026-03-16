//
//  ControlContainerView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 24/3/22.
//

import Foundation
import UIKit

protocol ControlContainerViewDelegate: AnyObject {
    func buttonHasPressed(itemId: String)
}

class ControlContainerView: NibLoadingView {
    // IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!
    
    // Private Properties
    private let vM: ControlContainerViewModel
    private weak var delegate: ControlContainerViewDelegate?
    
    // MARK: - Lifecycle
    required init(formControl: FormControlContainer, delegate: ControlContainerViewDelegate) {
        vM = .init(formControl: formControl)
        
        super.init(frame: .zero)
        
        self.delegate = delegate
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Private Functions
private extension ControlContainerView {
    func setupView() {
        view.layer.borderWidth = 1
        view.layer.borderColor = Asset.borderContainerControl.color.cgColor
        
        titleLabel.text = vM.title
        
        switch vM.type {
        case .Container:
            loadItemsForContainerType()
        case .DataGrid:
            print("Should load items for data grid")
        }
    }
    
    func loadItemsForContainerType() {
        for controlItem in vM.formControl.controls {
            if let itemView = vM.buildControl(controlItem: controlItem, delegate: self) {
                contentStackView.addArrangedSubview(itemView)

                let constraints = [
                    itemView.heightAnchor.constraint(equalToConstant: 30.0)
                ]

                NSLayoutConstraint.activate(constraints)
            }
        }
    }
}

// MARK: - ControlButtonViewDelegate Functions
extension ControlContainerView: ControlButtonViewDelegate {
    func buttonHasPressed(itemId: String) {
        delegate?.buttonHasPressed(itemId: itemId)
    }
}
