//
//  ControlButtonView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 28/3/22.
//

import Foundation
import UIKit
import RxSwift

protocol ControlButtonViewDelegate: AnyObject {
    func buttonHasPressed(itemId: String)
}

class ControlButtonView: NibLoadingView {
    // IBOutlets
    @IBOutlet weak var button: UIButton!
    
    // Private Properties
    private let vM: ControlButtonViewModel
    private weak var delegate: ControlButtonViewDelegate?
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    required init(buttonItem: FormControlItem, delegate: ControlButtonViewDelegate) {
        vM = .init(buttonItem: buttonItem)
        
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
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.buttonHasPressed(itemId: vM.id)
    }
    
}

// MARK: - Private Functions
private extension ControlButtonView {
    func setupView() {
        button.layer.borderWidth = 1
        button.layer.borderColor = Asset.borderContainerControl.color.cgColor
        
        button.setTitle(vM.title, for: .normal)
    }
}
