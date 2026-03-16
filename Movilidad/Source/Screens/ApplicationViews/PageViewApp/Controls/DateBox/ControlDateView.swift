//
//  ControlDateView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 29/3/22.
//

import Foundation
import UIKit

class ControlDateView: NibLoadingView {
    // IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textbox: UITextField!
    
    // Private Properties
    private let vM: ControlDateViewModel
    private var datePicker: UIDatePicker! {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        return datePickerView
    }
    
    // MARK: - Lifecycle
    required init(dateItem: FormControlItem) {
        vM = .init(dateItem: dateItem)
        
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
private extension ControlDateView {
    func setupView() {
        titleLabel.text = vM.title
        textbox.text = vM.textboxValue
        
        textbox.inputView = datePicker
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        textbox.text = dateFormatter.string(from: sender.date)
    }
}
