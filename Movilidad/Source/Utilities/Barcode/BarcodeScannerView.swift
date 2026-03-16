//
//  BarcodeScanner.swift
//  Movilidad
//
//  Created by Diego Quimbo on 13/4/22.
//

import Foundation
import UIKit
import ScanditCaptureCore
import ScanditBarcodeCapture

extension DataCaptureContext {
    private static let licenseKey = "AevHiteBQ4TKJ7pu5iQC1GkeaY6SLGneSRbPOZBbvDydf8eHSE2ycElIebNdZYPqZ3UD2hN7mit4d00+2073KNpyHd9Wd1HJCBPA4W5DNagfeBwJvlMIvSpVZhciXox++Fk1VaRk5ervf+sGLkLH1W46ugGJM6mZeQBJOzcqBKdIEO4HOruPdqw7Z3uYjQumCsB8DuDwxatCz+AKVhtstEQTYavASGPkVlnhRHhgzcqwyKQ4GlCN2yHs09vniRaeCI7dlTRpBSNkdiIAUhm7yopOz5Fsj+yieGT1a6jut4jYhHE/wN77tzkbdGPfq9PcbtnJ23TXCCvxgTgYnjxf383+4RkGnrPkBvY8FeO5IBfPCn5EBd/zsuj0k6HnOez6bz2mcYVCQOUUeCmTLc5ghUaAzYLPdP1R6OiKoTKjYLQaRrK7PAR4e55NV6/8y95TVqFtT9uiT0oscsR2MpHlry6o8NFoYoWqtiy3rJ7KDBe1oKAmDgxqG+xyrOt0SjHohVIylSYRFaOXZtZ6W+SXvlCr1Abdvl32VJqTWzQhFXA4vEhpFJXwC1LRdS/nlkS5lWa0KI8F8kRb+n59NyVMBWbc7QS1vZ/xPzrB3QwZTdZd9cOdI/x3S2Ipg9L2EsxJHt2qxHvMzTg36NBcR7XnnxUqe9Dv6GqMGjmSCTUe7bP3G8MtBIhN9Bqzw1RXLhn3AYu+02Jb6eznGQw7SZJ0BzfLvy7TpP7fyxgAM0H2CAk1eyTkk4d3YyAu8CMoEPEw6VfEInh4kCQvGuD+mtDZW3RHxOrNLFeikEYqk+/6SQGpvXD79SewAdvIrLeIyTyVDUcTrG9dRmGb062CGwzouBS1"

    // Get a licensed DataCaptureContext.
    static var licensed: DataCaptureContext {
        return DataCaptureContext(licenseKey: licenseKey)
    }
}

class BarcodeScannerView: NibLoadingView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var barcodeContentView: UIView!
    
    // MARK: - Properties
    private var codeOutputHandler: (_ code: String) -> Void
    
    private var context: DataCaptureContext!
    private var camera: Camera?
    private var barcodeCapture: BarcodeCapture!
    private var captureView: DataCaptureView!
    private var overlay: BarcodeCaptureOverlay!
    
    // MARK: - Initializer
    
    /**
     Creates a barcode scanner that catchs different code types
     
     - Parameter view: The view where the cam is going to be shown
     - Parameter codeOutputHandler: The closure that is executed when a code is scanned
     
     */
    required init(codeOutputHandler: @escaping (String) -> Void) {
        self.codeOutputHandler = codeOutputHandler
        
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setupRecognition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    @IBAction func pressedClose(_ sender: Any) {
        removeFromSuperview()
    }
    
    // MARK: - Public methods
    func startCaptureSession() {
        camera?.switch(toDesiredState: .on)
        
        // To visualize the on-going barcode capturing process on screen, setup a data capture view that renders the
        // camera preview. The view must be connected to the data capture context.
        captureView = DataCaptureView(context: context, frame: barcodeContentView.frame)
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        barcodeContentView.addSubview(captureView)
        
        // Add a barcode capture overlay to the data capture view to render the location of captured barcodes on top of
        // the video preview. This is optional, but recommended for better visual feedback.
        overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture, view: captureView, style: .frame)
        overlay.viewfinder = RectangularViewfinder(style: .square, lineStyle: .light)
    }
    
    func stoptCaptureSession() {
        barcodeCapture.isEnabled = false
        camera?.switch(toDesiredState: .off)
        
        captureView.removeFromSuperview()
    }
}

// MARK: - Private methods
private extension BarcodeScannerView {
    
    func setupRecognition() {
        // Create data capture context using your license key.
        context = DataCaptureContext.licensed

        // Use the world-facing (back) camera and set it as the frame source of the context. The camera is off by
        // default and must be turned on to start streaming frames to the data capture context for recognition.
        camera = Camera.default
        context.setFrameSource(camera, completionHandler: nil)

        // Use the recommended camera settings for the BarcodeCapture mode.
        let recommendedCameraSettings = BarcodeCapture.recommendedCameraSettings
        camera?.apply(recommendedCameraSettings)

        // The barcode capturing process is configured through barcode capture settings
        // and are then applied to the barcode capture instance that manages barcode recognition.
        let settings = BarcodeCaptureSettings()

        // Enable only the symbologies that the app requieres, every additional enabled symbology has an impact on processing times
//        settings.set(symbology: .ean13UPCA, enabled: true)
//        settings.set(symbology: .ean8, enabled: true)
//        settings.set(symbology: .upce, enabled: true)
        settings.set(symbology: .qr, enabled: true)
//        settings.set(symbology: .dataMatrix, enabled: true)
//        settings.set(symbology: .code39, enabled: true)
//        settings.set(symbology: .code128, enabled: true)
//        settings.set(symbology: .interleavedTwoOfFive, enabled: true)


        // Create new barcode capture mode with the settings from above.
        barcodeCapture = BarcodeCapture(context: context, settings: settings)

        // Register self as a listener to get informed whenever a new barcode got recognized.
        barcodeCapture.addListener(self)
    }
}


// MARK: - BarcodeCaptureListener
extension BarcodeScannerView: BarcodeCaptureListener {

    func barcodeCapture(_ barcodeCapture: BarcodeCapture,
                        didScanIn session: BarcodeCaptureSession,
                        frameData: FrameData) {
        guard let barcode = session.newlyRecognizedBarcodes.first else {
            return
        }

        // Get the human readable name of the symbology and assemble the result to be shown.
        let symbology = SymbologyDescription(symbology: barcode.symbology).readableName

        var result = "Scanned: "
        if let data = barcode.data {
            result += "\(data) "
        }
        result += "(\(symbology))"

        print(result)
        
        codeOutputHandler(result)
    }

}
