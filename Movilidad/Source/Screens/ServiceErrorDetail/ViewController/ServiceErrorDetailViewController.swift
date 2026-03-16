//
//  LoginErrorDetailViewController.swift
//  Movilidad
//
//  Created by Diego Quimbo on 24/1/22.
//

import UIKit

class ServiceErrorDetailViewController: UIViewController, NibLoadable {

    // IBOutlets
    @IBOutlet weak var detailErrorTextView: UITextView!
    
    // Properties
    let vM: ServiceErrorDetailViewModel
    var router: ServiceErrorDetailRouter?
    
    // MARK: - Life Cycle
    required init(viewModel: ServiceErrorDetailViewModel) {
        self.vM = viewModel
        super.init(nibName: ServiceErrorDetailViewController.nibName, bundle: ServiceErrorDetailViewController.bundle)
        
        self.router = .init(controller: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - IBActions
    @IBAction func closePressed(_ sender: Any) {
        router?.route(route: .back)
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        router?.route(route: .share)
    }
}

// MARK: - Private Functions
private extension ServiceErrorDetailViewController {
    func setupView() {
        detailErrorTextView.text = vM.errorDescription
    }
}
