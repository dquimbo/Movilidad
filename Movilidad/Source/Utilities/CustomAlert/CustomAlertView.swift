//
//  CustomAlertView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 25/7/22.
//

import Foundation
import UIKit

class CustomAlertView: NibLoadingView {
    
    // IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var mainButtonHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    required init(title: String, description: String, mainButtonHandler: (() -> Void)? = nil) {
        super.init(frame: .zero)
        
        self.mainButtonHandler = mainButtonHandler
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupView(title: title, description: description)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    @IBAction func acceptPressed(_ sender: Any) {
        mainButtonHandler?()
        removeFromSuperview()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        removeFromSuperview()
    }
}

// MARK: - Private Functions
private extension CustomAlertView {
    func setupView(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
