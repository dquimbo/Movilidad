//
//  PageAppView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 22/3/22.
//

import Foundation
import UIKit
import RxSwift

class PageAppView: NibLoadingView {
    
    // IBOutlets
    @IBOutlet weak var contentStackView: UIStackView!
    
    // Private Properties
    private let vM: PageAppViewModel
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    required init(operation: OperationItem, operationForm: OperationForm) {
        vM = .init(operation: operation, operationForm: operationForm)
        
        super.init(frame: .zero)
        
        self.accessibilityIdentifier = UUID().uuidString
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Private Functions
private extension PageAppView {
    func setupView() {
        buildViews()
    }
    
    func buildViews() {
        // Clear content view
        contentStackView.removeFullyAllArrangedSubviews()
        
        for formControl in vM.operationForm.controls {            
            let contentView1 = ControlContainerView(formControl: formControl, delegate: self)
            contentStackView.addArrangedSubview(contentView1)

            let height = vM.calculateHeightForFormContainer(formContainer: formControl)
            
            NSLayoutConstraint.activate([
                contentView1.heightAnchor.constraint(equalToConstant: height)
            ])
        }
    }
}

// MARK: - ControlContainerViewDelegate Functions
extension PageAppView: ControlContainerViewDelegate {
    func buttonHasPressed(itemId: String) {
        showProgressHud(view: self, text: L10n.General.Execute.app)
        
        vM.sendOperationTrigger(itemId: itemId)
            .subscribe { [weak self] operationData in
                guard let self = self else { return }
                
                self.hideProgressHud(view: self)
                
                self.buildViews()

            } onFailure: { [weak self] error in
                guard let self = self else { return }

                self.hideProgressHud(view: self.view)
            }.disposed(by: disposeBag)
    }
}
