//
//  AppPreviewCell.swift
//  Movilidad
//
//  Created by Diego Quimbo on 8/3/22.
//

import UIKit

protocol AppPreviewCellDelegate: AnyObject {
    func closeAppPreviewHasPressed(accessibilityIdentifier: String)
}

class AppPreviewCell: UICollectionViewCell, Reusable, NibLoadableView, ConfigurableView {
    // MARK: - Outlets
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    var vM: AppPreviewCellViewModel?
    weak var delegate: AppPreviewCellDelegate?
    
    // MARK: - Functions
    func configure(viewModel: AppPreviewCellViewModel) {
        self.vM = viewModel
        
        titleLabel.text = self.vM?.title
        backgroundImageView.image = self.vM?.backgroundImage
        topBarView.isHidden = self.vM?.hiddenTopBar ?? false
    }
    
    @IBAction func closePressed(_ sender: Any) {
        guard let identifier = vM?.accessibilityIdentifier else { return }
        
        delegate?.closeAppPreviewHasPressed(accessibilityIdentifier: identifier)
    }
}
