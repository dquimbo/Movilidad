//
//  DesktopAppView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 18/3/22.
//

import UIKit
import Foundation
import RxSwift

protocol DesktopContentAppViewDelegate: AnyObject {
    func closeDesktopAppView(accessibilityIdentifier: String)
    func favoriteHasPressed()
    func show(controller: UIViewController)
    func showPlayer(videoPath: String)
    func menuTapOutsideRecognizer()
    func openNewWebOperation(url: String)
    func updateNotificationsCount(count: Int)
}

class DesktopContentAppView: NibLoadingView {
    // IBOutlets
    @IBOutlet weak var contentAppView: UIView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var operationInfoView: UIView!
    @IBOutlet weak var debugViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var debugView: UIView!
    @IBOutlet weak var debugActionContentView: UIView!
    
    // Public Properties
    weak var delegate: DesktopContentAppViewDelegate?
    
    // Private Properties
    let vM: DesktopContentAppViewModel
    var appDebugWebViewLoaded = false
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    required init(operation: OperationItem?, externalOperationWebView: OperationWeb?, delegate: DesktopContentAppViewDelegate) {
        vM = .init(operation: operation, externalOperationWebView: externalOperationWebView)
        
        super.init(frame: .zero)
        
        self.delegate = delegate
        self.accessibilityIdentifier = UUID().uuidString
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    @IBAction func pressedClose(_ sender: Any) {
        guard let identifier = accessibilityIdentifier else { return }
        
        delegate?.closeDesktopAppView(accessibilityIdentifier: identifier)
    }
    
    @IBAction func pressedFavorite(_ sender: Any) {
        vM.pressedFavoriteButton()

        favoriteImageView.image = vM.favoriteImageStatus

        delegate?.favoriteHasPressed()
    }
    
    @IBAction func pressedReload(_ sender: Any) {
        if let applicationView = contentAppView.viewWithTag(1) as? ApplicationWebView? {
            applicationView?.reloadApplicationView()
        }
    }
    
    @objc func viewTapRecognizer(_ sender: UITapGestureRecognizer) {
        delegate?.menuTapOutsideRecognizer()
    }
    
    @IBAction func operationStatusInfoPressed(_ sender: Any) {
        // Close debugView to avoid navigation view conflicts
        slideMoveDebugView(open: false)
        
        handleOperationStatusInfoPressed()
        
        vM.isShowingStatusOperationInfo.toggle()
    }
    
    @IBAction func debugPressed(_ sender: Any) {
        slideMoveDebugView(open: debugViewLeadingConstraint.constant == 0)
    }
}

// MARK: - Private Functions
private extension DesktopContentAppView {
    func setupView() {
        favoriteImageView.image = vM.favoriteImageStatus
        
        titleLabel.text = vM.operationTitle
        
        loadAppInfo()
        
        // This tap gesture is used in order to hide the slide menu when the user tap outside of it
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapRecognizer(_:)))
        addGestureRecognizer(tap)
    }
    
    func addOperationView(operationView: UIView) {
        operationView.translatesAutoresizingMaskIntoConstraints = false
        
        contentAppView.addSubview(operationView)
        
        let constraints = [
            operationView.leadingAnchor.constraint(equalTo: contentAppView.leadingAnchor, constant: 0),
            operationView.trailingAnchor.constraint(equalTo: contentAppView.trailingAnchor, constant: 0),
            operationView.topAnchor.constraint(equalTo: contentAppView.topAnchor, constant: 0),
            operationView.bottomAnchor.constraint(equalTo: contentAppView.bottomAnchor, constant: 0)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    func loadAppInfo() {
        // Check if operation belongs to workflows
        if vM.isExternalOperationWebView, let operation = vM.externalOperationWebView {
            debugActionContentView.isHidden = true
            showExternalWebOperation(operationInfo: operation)
            return
        }
        
        // If the operations is not workflow type, try to get the operation data
        showProgressHud(view: self, text: L10n.General.Execute.app)
        
        vM.getOperationInfo()
            .subscribe { [weak self] operationData in
                guard let self = self else { return }
                
                self.hideProgressHud(view: self)

                self.buildOperationView(operationData: operationData)
            } onFailure: { [weak self] error in
                guard let self = self else { return }

                self.hideProgressHud(view: self.view)
                self.showGenericError(message: L10n.General.Error.app)
            }.disposed(by: disposeBag)
    }
    
    func showGenericError(message: String) {
        self.hideProgressHud(view: self.view)
        
        showAlert(title: L10n.General.Error.title, message: message)
    }
    
    func showExternalWebOperation(operationInfo: OperationWeb?) {
        guard let operationInfoObj = operationInfo else {
            self.showGenericError(message: L10n.General.Error.app)
            return
        }
        
        debugActionContentView.isHidden = true
        
        let appWebView = ApplicationWebView(operationInfo: operationInfoObj, delegate: self)
        
        addOperationView(operationView: appWebView)
    }
    
    func showPageOperation(operationForm: OperationForm?) {
        guard let operationFormObj = operationForm, let operationWrap = vM.operation else {
            self.showGenericError(message: L10n.General.Error.app)
            return
        }

        let pageView = PageAppView(operation: operationWrap, operationForm: operationFormObj)
        
        addOperationView(operationView: pageView)
    }
    
    func buildOperationView(operationData: String) {
        switch vM.getHandlerTypeByOperationData(data: operationData) {
        case .ExternalWeb:
            let operation = OperationWeb(XMLString: operationData)
            showExternalWebOperation(operationInfo: operation)
        case .Page:
            let operation = OperationForm(XMLString: operationData)
            showPageOperation(operationForm: operation)
        default:
            return
        }
    }
    
    func handleOperationStatusInfoPressed() {
        let fromView = vM.isShowingStatusOperationInfo ? operationInfoView : contentAppView
        let toView = vM.isShowingStatusOperationInfo ? contentAppView : operationInfoView
        let flipDirection: UIView.AnimationOptions = vM.isShowingStatusOperationInfo ? .transitionFlipFromRight : .transitionFlipFromLeft
        
        let options: UIView.AnimationOptions = [flipDirection, .showHideTransitionViews]
        
        guard let unwrappedFromView = fromView,
        let unwrappedToView = toView else {
            return
        }
        
        UIView.transition(from: unwrappedFromView, to: unwrappedToView, duration: 0.6, options: options)
    }
    
    func slideMoveDebugView(open: Bool) {
        debugViewLeadingConstraint.constant = open ? -contentAppView.frame.width : 0
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        } completion: {[weak self] _ in
            guard let self = self else { return }
            
            if !appDebugWebViewLoaded {
                // Load debug view only once
                appDebugWebViewLoaded = true
                loadDebugWebView()
            }
        }
    }
    
    func loadDebugWebView() {
        let debugWeb = OperationWeb(externalURL: vM.debugWebViewURL)
        
        let appDebugWebView = ApplicationWebView(operationInfo: debugWeb, delegate: self)
        
        appDebugWebView.translatesAutoresizingMaskIntoConstraints = false
        
        debugView.addSubview(appDebugWebView)
        
        let constraints = [
            appDebugWebView.leadingAnchor.constraint(equalTo: debugView.leadingAnchor, constant: 0),
            appDebugWebView.trailingAnchor.constraint(equalTo: debugView.trailingAnchor, constant: 0),
            appDebugWebView.topAnchor.constraint(equalTo: debugView.topAnchor, constant: 0),
            appDebugWebView.bottomAnchor.constraint(equalTo: debugView.bottomAnchor, constant: 0)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - ApplicationWebViewDelegate
extension DesktopContentAppView: ApplicationWebViewDelegate {
    
    func show(controller: UIViewController) {
        delegate?.show(controller: controller)
    }
    
    func showPlayer(videoPath: String) {
        delegate?.showPlayer(videoPath: videoPath)
    }
    
    func webViewTapRecognizer() {
        delegate?.menuTapOutsideRecognizer()
    }
    
    func openNewWebOperation(url: String) {
        delegate?.openNewWebOperation(url: url)
    }
    
    func updateNotificationsCount(count: Int?) {
        guard let notificationCount = count else { return }
        
        delegate?.updateNotificationsCount(count: notificationCount)
    }
}
