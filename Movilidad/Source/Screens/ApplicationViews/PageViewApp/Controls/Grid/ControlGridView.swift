//
//  ControlGridView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 8/6/22.
//

import Foundation
import UIKit

class ControlGridView: NibLoadingView {
    // IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // Private Properties
    private let vM: ControlGridViewModel
    
    // MARK: - Lifecycle
    required init(gridItem: FormControlItem) {
        vM = .init(gridItem: gridItem)
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Private Functions
private extension ControlGridView {
    func setupView() {
        titleLabel.text = vM.title
    }
}
