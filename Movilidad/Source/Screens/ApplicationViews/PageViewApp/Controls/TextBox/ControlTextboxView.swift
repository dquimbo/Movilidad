//
//  ControlTextboxView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 25/3/22.
//

import Foundation
import UIKit

class ControlTextboxView: NibLoadingView {
    // IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textbox: UITextField!
    
    @IBOutlet weak var barcodeView: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.barcodeTap(_:)))
            barcodeView.addGestureRecognizer(tap)
            barcodeView.isUserInteractionEnabled = true
        }
    }
    
    // Private Properties
    private let vM: ControlTextboxViewModel
//    private lazy var barcodeScanner = BarcodeScanner(codeOutputHandler: handleBarcode)
    
    // MARK: - Lifecycle
    required init(textboxItem: FormControlItem) {
        vM = .init(textboxItem: textboxItem)
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    @objc func barcodeTap(_ sender: UITapGestureRecognizer) {
        showBarcodeView()
    }
}

// MARK: - Private Functions
private extension ControlTextboxView {
    func setupView() {
        titleLabel.text = vM.title
        textbox.text = vM.textboxValue
        textbox.isUserInteractionEnabled = !vM.readonly
        
        barcodeView.isHidden = !vM.shouldShowBarcode
    }
    
    func showBarcodeView() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })  else {
            return
        }
        
        let barcodeView = BarcodeScannerView(codeOutputHandler: handleBarcode(code:))
        barcodeView.startCaptureSession()
        
        window.addSubview(barcodeView)
        
        NSLayoutConstraint.activate([
            barcodeView.topAnchor.constraint(equalTo: window.topAnchor),
            barcodeView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            barcodeView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            barcodeView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
    }
    
    func handleBarcode(code: String) {
        textbox.text = code
    }
}
