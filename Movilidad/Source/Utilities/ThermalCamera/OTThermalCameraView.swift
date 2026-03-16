//
//  OTThermalCameraView.swift
//  iPadMiddlewareClient
//
//  Created by Diego Quimbo on 28/12/22.
//  Copyright © 2022 Ternium. All rights reserved.
//

import UIKit
import ThermalSDK

class OTThermalCameraView: UIView {
    
    var discovery: FLIRDiscovery?
    var camera: FLIRCamera?
    
    var thermalStreamer: FLIRThermalStreamer?
    var stream: FLIRStream?
    
    let renderQueue = DispatchQueue(label: "render")
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var centerSpotLabel: UILabel!
    @IBOutlet weak var contentCameraView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    func initCamera() {
        discovery = FLIRDiscovery()
        discovery?.delegate = self

        contentCameraView.isHidden = true
        
        discovery?.start(.lightning)
        
        loadingIndicator.isHidden = false
    }

    @IBAction func disconnectClicked(_ sender: Any) {
        camera?.disconnect()
        
        self.contentCameraView.isHidden = true
        self.loadingIndicator.isHidden = true
    }
}

private extension OTThermalCameraView {
    func requireCamera() {
        guard camera == nil else {
            return
        }
        let camera = FLIRCamera()
        self.camera = camera
        
        camera.delegate = self
    }
}

extension OTThermalCameraView: FLIRDiscoveryEventDelegate {
    func cameraFound(_ cameraIdentity: FLIRIdentity) {
        switch cameraIdentity.cameraType() {
        case .flirOne:
            requireCamera()
            guard !camera!.isConnected() else {
                return
            }
            DispatchQueue.global().async {
                do {
                    try self.camera?.connect(cameraIdentity)
                    let streams = self.camera?.getStreams()
                    guard let stream = streams?.first else {
                        NSLog("No streams found on camera!")
                        return
                    }
                    self.stream = stream
                    
                    self.thermalStreamer = FLIRThermalStreamer(stream: stream)
                    self.thermalStreamer?.autoScale = true
                    self.thermalStreamer?.renderScale = true
                    stream.delegate = self
                    do {
                        try stream.start()
                    } catch {
                        NSLog("stream.start error \(error)")
                    }
                } catch {
                    NSLog("Camera connect error \(error)")
                }
            }
        case .generic:
            ()
        @unknown default:
            fatalError("unknown cameraType")
        }
    }
    
    func discoveryError(_ error: String, netServiceError nsnetserviceserror: Int32, on iface: FLIRCommunicationInterface) { }

    func discoveryFinished(_ iface: FLIRCommunicationInterface) { }

    func cameraLost(_ cameraIdentity: FLIRIdentity) { }
}

extension OTThermalCameraView: FLIRDataReceivedDelegate {
    func onDisconnected(_ camera: FLIRCamera, withError error: Error?) {
        NSLog("\(#function) \(String(describing: error))")
        DispatchQueue.main.async {
            self.thermalStreamer = nil
            self.stream = nil
//            let alert = UIAlertController(title: "Disconnected",
//                                          message: "Flir One disconnected",
//                                          preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
            print("Show alert camera disconected")
            
            self.contentCameraView.isHidden = true
            self.loadingIndicator.isHidden = true
        }
    }
}

extension OTThermalCameraView: FLIRStreamDelegate {
    func onImageReceived() {
        renderQueue.async {
            do {
                try self.thermalStreamer?.update()
            } catch {
                NSLog("update error \(error)")
            }
            let image = self.thermalStreamer?.getImage()
            DispatchQueue.main.async {
                self.contentCameraView.isHidden = false
                self.loadingIndicator.isHidden = true
                
                self.imageView.image = image
                self.thermalStreamer?.withThermalImage { image in
                    if image.palette?.name == image.paletteManager?.iron.name {
//                        if !self.ironPalette {
//                            image.palette = image.paletteManager?.gray
//                        }
                    } else {
                        image.palette = image.paletteManager?.iron
                    }
                    if let measurements = image.measurements {
                        if measurements.getAllSpots().isEmpty {
                            do {
                                try measurements.addSpot(CGPoint(x: CGFloat(image.getWidth()) / 2,
                                                                 y: CGFloat(image.getHeight()) / 2))
                            } catch {
                                NSLog("addSpot error \(error)")
                            }
                        }
                        if let spot = measurements.getAllSpots().first {
                            self.centerSpotLabel.text = spot.getValue().asCelsius().description()
                        }
                    }
                }
            }
        }
    }
    
    func onError(_ error: Error) { }
}

// UIView + Nib
extension UIView {
    
    @objc
    public class func fromNib() -> Self {
        return fromNib(nibName: nil)
    }
    
    @objc
    public class func fromNib(nibName: String?) -> Self {
        func fromNibHelper<T>(nibName: String?) -> T where T: UIView {
            let bundle = Bundle(for: T.self)
            let name = nibName ?? String(describing: T.self)
            return bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T ?? T()
        }
        return fromNibHelper(nibName: nibName)
    }
}
