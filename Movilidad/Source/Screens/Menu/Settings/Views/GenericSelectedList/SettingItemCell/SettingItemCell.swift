//
//  SettingItemCell.swift
//  Movilidad
//
//  Created by Diego Quimbo on 9/2/22.
//

import UIKit

class SettingItemCell: UITableViewCell, Reusable, NibLoadableView, ConfigurableView {
    // IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    // Public Vars
    var vM: SettingItemViewModel?

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Functions
    func configure(viewModel: SettingItemViewModel) {
        self.vM = viewModel

        setupStyle()
    }

    // MARK: - Private Functions
    private func setupStyle() {
        selectionStyle = .none
        
        guard let viewModel = self.vM else { return }
        
        titleLabel.text = viewModel.title
        checkImageView.isHidden = !viewModel.isCellItemSelected
        separatorView.isHidden = viewModel.isLastCellItem
        
        roundCorners()
    }
    
    private func roundCorners() {
        guard let viewModel = self.vM else { return }
        if viewModel.isFirstCellItem {
            self.contentView.roundCorners(radius: 10, corners: [.topLeft, .topRight])
        } else if viewModel.isLastCellItem {
            self.contentView.roundCorners(radius: 10, corners: [.bottomLeft, .bottomRight])
        } else {
            self.contentView.roundCorners(radius: 0, corners: [.allCorners])
        }
    }
}
