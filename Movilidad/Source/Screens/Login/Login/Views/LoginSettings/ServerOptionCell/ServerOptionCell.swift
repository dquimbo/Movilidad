//
//  ServerOptionCell.swift
//  Movilidad
//
//  Created by Diego Quimbo on 17/1/22.
//

import UIKit
//import DropDown

protocol ServerOptionCellDelegate: AnyObject {
    func removeOptionPressed(index: Int)
}

class ServerOptionCell: DropDownCell {
    // IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    // Properties
    weak var delegate: ServerOptionCellDelegate?
    var indexItem: Int = 0
    
    // MARK: - IBActions
    @IBAction func removePressed(_ sender: Any) {
        delegate?.removeOptionPressed(index: indexItem)
    }
}
