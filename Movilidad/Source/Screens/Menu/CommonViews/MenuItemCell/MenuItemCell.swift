//
//  TransactionCell.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/2/22.
//

import UIKit

class MenuItemCell: UITableViewCell, Reusable, NibLoadableView, ConfigurableView {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: - Properties
    var vM: MenuItemCellViewModel?
    
    // MARK: - Functions
    func configure(viewModel: MenuItemCellViewModel) {
        self.vM = viewModel

        setupStyle()
    }

    // MARK: - Private Functions
    private func setupStyle() {
        selectionStyle = .none
        
        guard let viewModel = self.vM else { return }
        
        titleLabel.text = viewModel.title
        iconImageView.image = viewModel.icon
        
        let cornerRadius = viewModel.isLastCellItem ? 10.0 : 0.0
        self.contentView.roundCorners(radius: cornerRadius, corners: [.bottomLeft, .bottomRight])
        
        separatorView.isHidden = viewModel.isLastCellItem
    }
    
}
