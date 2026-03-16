//
//  FavoriteAppCell.swift
//  Movilidad
//
//  Created by Diego Quimbo on 14/3/22.
//

import UIKit

class FavoriteAppCell: UITableViewCell, Reusable, NibLoadableView, ConfigurableView {
    // MARK: - Outlets
    @IBOutlet weak var titlelabel: UILabel!
    
    // MARK: - Properties
    var viewModel: FavoriteAppCellViewModel?
    
    // MARK: - Functions
    func configure(viewModel: FavoriteAppCellViewModel) {
        self.viewModel = viewModel
        
        setupCell()
    }
    
    private func setupCell() {
        titlelabel.text = viewModel?.title
    }
}
