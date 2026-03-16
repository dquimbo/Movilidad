//
//  MenuHeaderCell.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/2/22.
//

import UIKit

class MenuHeaderCell: UIView, Reusable, NibLoadableView {
 
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(viewModel: MenuHeaderCellViewModel) {
        titleLabel.text = viewModel.title
        self.contentView.roundCorners(radius: 10, corners: [.topLeft, .topRight])
    }
}
