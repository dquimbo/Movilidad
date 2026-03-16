//
//  GeneralSearchCell.swift
//  Movilidad
//
//  Created by Diego Quimbo on 23/5/22.
//

import UIKit

class GeneralSearchCell: UITableViewCell, Reusable, NibLoadableView, ConfigurableView {
    // MARK: - Outlets
    @IBOutlet weak var titlelabel: UILabel!
    
    // MARK: - Properties
    var viewModel: GeneralSearchCellViewModel?
    
    // MARK: - Functions
    func configure(viewModel: GeneralSearchCellViewModel) {
        self.viewModel = viewModel
        
        setupCell()
    }
    
    private func setupCell() {
        titlelabel.text = viewModel?.title
    }
}
