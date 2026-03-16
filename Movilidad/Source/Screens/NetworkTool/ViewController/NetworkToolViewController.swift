//
//  NetworkToolViewController.swift
//  Movilidad
//
//  Created by Diego Quimbo on 4/5/23.
//

import UIKit
//import DropDown

class NetworkToolViewController: UIViewController, NibLoadable {
    // IBOutlets
    @IBOutlet weak var serverTextfield: UITextField!
    @IBOutlet weak var outputMessageTextView: UITextView!
    
    // Properties
    private let vM: NetworkToolViewModel
    private var router: NetworkToolRouter?
    private let serverOptionsDropDown = DropDown()
//    private var pinger: SimplePing?
    private var startPing: Date = Date()
    
    // MARK: - Life Cycle
    required init(viewModel: NetworkToolViewModel) {
        self.vM = viewModel
        super.init(nibName: NetworkToolViewController.nibName, bundle: NetworkToolViewController.bundle)
        
        self.router = .init(controller: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupServerOptionsDropDown()
    }
    
    // MARK: - IBActions
    @IBAction func cancelPressed(_ sender: Any) {
        router?.route(route: .back)
    }
    
    @IBAction func selectServerPressed(_ sender: Any) {
        serverOptionsDropDown.show()
    }
    
    @IBAction func pingPressed(_ sender: Any) {
        guard let serverSelected = serverTextfield.text, !(serverSelected.isEmpty) else { return }
        vM.saveServedSelected(server: serverSelected)
        
        pingServer()
    }
    
    @IBAction func getIPAddressPressed(_ sender: Any) {
//        guard let strIPAddress = IPAddressHandler().getIPAddress() else { return }
//
//        writeOutputMessage(message: "Network IP Addresses:\n\(strIPAddress)")
    }
    
    @IBAction func clearPressed(_ sender: Any) {
        outputMessageTextView.text = ""
    }
}

// MARK: - Private Functions
private extension NetworkToolViewController {
    func setupServerOptionsDropDown() {
        // The view to which the drop down will appear on
        serverOptionsDropDown.anchorView = serverTextfield
        
        // Show DropDown below the anchor view
        serverOptionsDropDown.direction = .bottom
        serverOptionsDropDown.bottomOffset = CGPoint(x: 0, y: serverTextfield.bounds.height)
        
        // DataSource
        serverOptionsDropDown.dataSource = SettingsHandler.shared.servers
        
        serverOptionsDropDown.cellNib = UINib(nibName: "ServerOptionCell", bundle: nil)
        serverOptionsDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? ServerOptionCell else { return }
            
            // Setup your custom UI components
            cell.indexItem = index
            cell.removeButton.isHidden = true
        }
        
        // Action triggered on selection
        serverOptionsDropDown.selectionAction = { [weak self] (index, item) in
            self?.serverTextfield.text = item
        }
    }
    
    func pingServer() {
//        guard let hostName = vM.serverSelected else { return }
//        pinger = SimplePing(hostName: hostName)
//        pinger?.delegate = self
//        pinger?.start()
    }
    
    func writeOutputMessage(message: String) {
        let message = "\(outputMessageTextView.text ?? "")\(message)\n"
        
        outputMessageTextView.text = message
    }
}

// MARK: - SimplePingDelegate
//extension NetworkToolViewController: SimplePingDelegate {
//    @objc func sendPing() {
//        pinger!.send(with: nil)
//    }
//
//    func stop() {
//        pinger?.stop()
//        pinger = nil
//
//        writeOutputMessage(message: "\n")
//    }
//
//    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
//        writeOutputMessage(message: L10n.Network.Tool.Start.ping(vM.serverSelected ?? ""))
//        sendPing()
//    }
//
//    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
//        writeOutputMessage(message: L10n.Network.Tool.Start.Ping.error(vM.serverSelected ?? ""))
//        stop()
//    }
//
//    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
//        startPing = Date()
//        writeOutputMessage(message: L10n.Network.Tool.Packet.sent(sequenceNumber))
//    }
//
//    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
//        writeOutputMessage(message: L10n.Network.Tool.Packet.Sent.error(sequenceNumber))
//        stop()
//    }
//
//    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
//        let interval = startPing.distance(to: Date()) * 1000
//
//        writeOutputMessage(message: L10n.Network.Tool.Packet.received(sequenceNumber, interval.round(to: 7)))
//        stop()
//    }
//
//    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) { }
//}
