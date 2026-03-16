//
//  ControlCheckbox.swift
//  Movilidad
//
//  Created by Diego Quimbo on 28/4/22.
//

import Foundation
import UIKit

class ControlCheckbox: NibLoadingView {
    // IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkedButton: UIButton!
    
    // Private Properties
    private let vM: ControlCheckboxViewModel
    
    // MARK: - Lifecycle
    required init(checkboxItem: FormControlItem) {
        vM = .init(checkboxItem: checkboxItem)
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    @IBAction func checkboxPressed(_ sender: Any) {
        
        vM.switchCheck()
        checkedButton.setImage(vM.getCheckboxImage(), for: .normal)
    }
    
}

// MARK: - Private Functions
private extension ControlCheckbox {
    func setupView() {
        titleLabel.text = vM.title
        
        checkedButton.setImage(vM.getCheckboxImage(), for: .normal)
    }
}
