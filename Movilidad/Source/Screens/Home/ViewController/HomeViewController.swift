//
//  HomeViewController.swift
//  MovilidadUK
//
//  Created by Diego Quimbo on 4/1/22.
//

import UIKit
import RxSwift
import AVFoundation
import AVKit

class HomeViewController: UIViewController, NibLoadable {
    // IBOutlets
    @IBOutlet weak var slideMenuView: MenuSlideView! {
        didSet {
            slideMenuView.delegate = self
        }
    }
    @IBOutlet weak var menuTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var infiniteScrollView: InfiniteScrollView!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    
    // Public Properties
    let vM: HomeViewModel
    
    // Private Properties
    private var router: HomeRouter?
    private var welcomeView = WelcomeView(frame: .zero)
    
    private var metroStartView = MetroStartView(frame: .zero)
    
    private var refreshNotificationCount: Timer?
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    required init(viewModel: HomeViewModel) {
        self.vM = viewModel
        super.init(nibName: HomeViewController.nibName, bundle: HomeViewController.bundle)
        
        self.router = .init(controller: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadDataFromServer()
        addObservers()
        startRefreshingNotificationsCount()
        
        slideMenuView.setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        slideMenuView.reloadLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Handling rotation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.infiniteScrollView.layoutWillChange(size: size)
        }
    }
    
    deinit {
         // Remove observer to avoid retain cycles
         NotificationCenter.default.removeObserver(self)
     }
    
    // MARK: - IBActions
    @IBAction func menuPressed(_ sender: Any) {
        slideMenuMove(toClose: menuTrailingConstraint.constant < 0)
    }
    
    @IBAction func appSwitcherPressed(_ sender: Any) {
        let appsSwitcher = getApplicationsOpened()
        router?.route(route: .appSwitcher(appsSwitcher: appsSwitcher))
    }
    
    @IBAction func homePressed(_ sender: Any) {
        // Return to home screen
        infiniteScrollView.scrollToView(index: 0)
    }
    
    @IBAction func notificationsPressed(_ sender: Any) {
        let operationExternalWeb = vM.buildExternalOperationNotifications()
        showDesktopApplication(externalOperationWebView: operationExternalWeb)
    }
}

// MARK: - Getting Data From Server
private extension HomeViewController {
    func setupView() {
        
        self.welcomeView.delegate = self
    }
    
    func loadDataFromServer() {
        showProgressHud(view: view, text: L10n.Home.Loading.profile)
        
        vM.getProfile()
            .subscribe { [weak self] success in
                guard let self = self else { return }
                
                if success {
                    self.handleProfileResponse()
                } else {
                    self.showGenericError(message: L10n.Home.Error.profile, withDetailButton: true)
                }
            } onFailure: { error in
                self.showGenericError(message: L10n.Home.Error.profile, withDetailButton: true)
            }.disposed(by: disposeBag)
        
        vM.getNotificationsCount()
            .subscribe { [weak self] value in
                guard let self = self else { return }
                
                self.loadNotificationsBadge(notificationsCount: value)
                
            } onFailure: { error in
                self.showGenericError(message: L10n.Home.Error.profile)
            }.disposed(by: disposeBag)
        
        vM.registerPushNotifications()
    }
    
    func handleProfileResponse() {
        self.hideProgressHud(view: self.view)
        
        guard vM.hasLicence else {
            let alert = UIAlertController(title: L10n.General.Error.title, message: L10n.Home.Error.licence, preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.router?.route(route: .back)
            }))
            
            self.present(alert, animated: true)
            return
        }
        
        loadMenuData()
    }
    
    func showGenericError(message: String, withDetailButton: Bool = false) {
        self.hideProgressHud(view: self.view)
        
        if withDetailButton {
            showAlertWithHandler(title: L10n.General.Error.title,
                                 message: message,
                                 actionTitle: L10n.Login.Watch.detail,
                                 cancelTitle: "Ok") { _ in
                self.router?.route(route: .serviceErrorDetail)
            }
        } else {
            showAlert(title: L10n.General.Error.title, message: message)
        }
    }
    
    func loadMenuData() {
        showProgressHud(view: view, text: L10n.Home.Loading.menu)
        
        vM.getMenu().subscribe { [weak self] success in
            guard let self = self else { return }
            
            self.hideProgressHud(view: self.view)
            self.loadAdditionalProfileInfo()
        } onFailure: { error in
            self.hideProgressHud(view: self.view)
            self.showGenericError(message: L10n.Home.Error.menu, withDetailButton: true)
        }.disposed(by: disposeBag)
    }
    
    func loadAdditionalProfileInfo() {
        showProgressHud(view: view, text: L10n.Home.Loading.info)
        
        vM.getAdditionalProfileInfo().subscribe { [weak self] success in
            guard let self = self else { return }
            
            self.hideProgressHud(view: self.view)
            
            self.loadInViewAdditionalProfileInfo()
            self.slideMenuView.reloadData()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            
            self.hideProgressHud(view: self.view)
            self.showGenericError(message: L10n.Home.Error.menu, withDetailButton: true)
        }.disposed(by: disposeBag)
    }
    
    func loadInViewAdditionalProfileInfo() {
        welcomeView.refreshData()
        
        self.infiniteScrollView.datasource = [welcomeView]
        
        checkIfExistInitialOperation()
    }
    
    func getApplicationsOpened() -> [AppSwitcher] {
        guard let viewsInScroll = infiniteScrollView.datasource else { return [] }
        
        var appsSwitcher: [AppSwitcher] = []
        
        for view in viewsInScroll {
            if let viewContent = view as? DesktopContentAppView {
                let appSwitcher = AppSwitcher(accessibilityIdentifier: viewContent.accessibilityIdentifier,
                                              title: viewContent.vM.operationTitle,
                                              backgroundImage: viewContent.snapshot,
                                              topBarIsNeeded: true)
                appsSwitcher.append(appSwitcher)
            } else if ((view as? WelcomeView) != nil) || ((view as? MetroStartView) != nil) {
                let appSwitcher = AppSwitcher(accessibilityIdentifier: view.accessibilityIdentifier,
                                              title: "",
                                              backgroundImage: view.snapshot,
                                              topBarIsNeeded: false)
                appsSwitcher.append(appSwitcher)
            }
        }
        
        return appsSwitcher
    }
    
    func loadNotificationsBadge(notificationsCount: Int) {
        badgeView.isHidden = notificationsCount == 0
        badgeLabel.text = "\(notificationsCount)"
        
        UIApplication.shared.applicationIconBadgeNumber = notificationsCount
    }
}

// MARK: - Private functions
private extension HomeViewController {
    func logout() {
        refreshNotificationCount?.invalidate()
        refreshNotificationCount = nil
        
        router?.route(route: .back)
    }
    
    func showDesktopApplication(operation: OperationItem? = nil, externalOperationWebView: OperationWeb? = nil) {
        slideMenuMove(toClose: true)
        
        let appDesktopView = DesktopContentAppView(operation: operation, externalOperationWebView: externalOperationWebView, delegate: self)
        infiniteScrollView.insertView(newView: appDesktopView)
    }
    
    func startRefreshingNotificationsCount() {
        if refreshNotificationCount == nil {
            refreshNotificationCount = Timer.scheduledTimer(timeInterval: 5,
                                                         target: self,
                                                         selector: #selector(fireRefreshNotificationsCount),
                                                         userInfo: nil,
                                                         repeats: true)
        }
        
        refreshNotificationCount?.fire()
    }
    
    @objc private func fireRefreshNotificationsCount() {
        vM.getNotificationsCount()
            .subscribe { [weak self] value in
                guard let self = self else { return }
                
                self.loadNotificationsBadge(notificationsCount: value)
                
            }.disposed(by: disposeBag)
    }
}

// MARK: - Menu
private extension HomeViewController {
    func slideMenuMove(toClose: Bool) {
        menuTrailingConstraint.constant = toClose ? 0 : -slideMenuView.frame.width
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func checkIfExistInitialOperation() {
        guard let initialOperation =  SettingsHandler.shared.getInitialOperation() else {
            checkInitInMetroDesktop()
            return
        }

        showDesktopApplication(operation: initialOperation)
    }
    
    func checkInitInMetroDesktop() {
        if SettingsHandler.shared.initInMetroDesktop {
            metroStartView.delegate = self
            infiniteScrollView.insertView(newView: metroStartView)
        }
    }
}

// MARK: - MenuSlideViewDelegate
extension HomeViewController: MenuSlideViewDelegate, WelcomeViewDelegate {
    func favoriteOperationHasSelected(operation: OperationItem) {
        showDesktopApplication(operation: operation)
    }
    
    func searchedOperationHasSelected(operation: OperationItem) {
        showDesktopApplication(operation: operation)
    }
    
    func changeProfileHasPressed(source: UIView) {
        let profileListVC = GenericItemsSettingsViewController(actionType: .profileSelected, isPopover: true)
        profileListVC.modalPresentationStyle = .popover
        profileListVC.popoverPresentationController?.sourceView = source
        
        present(profileListVC, animated: true)
    }
    
    func transactionItemHasSelected(operation: OperationItem) {
        slideMenuMove(toClose: true)
        showDesktopApplication(operation: operation)
    }
    
    func appItemHasSelected(operation: OperationItem) {
        slideMenuMove(toClose: true)
        showDesktopApplication(operation: operation)

    }
    
    func workflowItemHasSelected(operation: OperationItem) {
        slideMenuMove(toClose: true)
        let operationWorkflowWeb = vM.buildOperationForWorkflow(operation: operation)
        showDesktopApplication(operation: operation, externalOperationWebView: operationWorkflowWeb)
    }
}

// MARK: - ApplicationWebViewDelegate
extension HomeViewController: DesktopContentAppViewDelegate {
    func closeDesktopAppView(accessibilityIdentifier: String) {
        infiniteScrollView.removeView(accessibilityIdentifier: accessibilityIdentifier)
    }

    func favoriteHasPressed() {
        self.welcomeView.refreshData()
    }
    
    func show(controller: UIViewController) {
        present(controller, animated: true)
    }
    
    func showPlayer(videoPath: String) {
        let player = AVPlayer(url: URL(fileURLWithPath: videoPath))
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        present(playerController, animated: true) {
            playerController.player?.play()
        }
    }
    
    func menuTapOutsideRecognizer() {
        if menuTrailingConstraint.constant < 0 {
            slideMenuMove(toClose: true)
        }
    }
    
    func openNewWebOperation(url: String) {
        let operationExternalWeb = vM.buildExternalOperationTriggedFromWebView(url: url)
        showDesktopApplication(externalOperationWebView: operationExternalWeb)
    }
    
    func updateNotificationsCount(count: Int) {
        loadNotificationsBadge(notificationsCount: count)
    }
}

// MARK: - AppSwitcherViewControllerDelegate
extension HomeViewController: AppSwitcherViewControllerDelegate {
    func switchAppHasSelected(index: Int) {
        router?.route(route: .dismissModal)
        infiniteScrollView.scrollToView(index: index)
    }
    
    func switchAppHasClosed(accessibilityIdentifier: String) {
        infiniteScrollView.removeView(accessibilityIdentifier: accessibilityIdentifier)
    }
}

// MARK: - Observers
private extension HomeViewController {
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(profileSelectedHasChanged(_:)), name: .profileSelectedHasChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logoutFromMenuSettings(_:)), name: .logout, object: nil)
    }
    
    @objc func profileSelectedHasChanged(_ notification: NSNotification) {
        // Reload menu
        showProgressHud(view: view, text: L10n.Home.Loading.menu)
        
        vM.getMenu().subscribe { [weak self] success in
            guard let self = self else { return }
            
            self.hideProgressHud(view: self.view)
            
            self.welcomeView.refreshData()
            self.slideMenuView.reloadData()

        } onFailure: { error in
            self.hideProgressHud(view: self.view)
            self.showGenericError(message: L10n.Home.Error.menu)
        }.disposed(by: disposeBag)
    }
    
    @objc func logoutFromMenuSettings(_ notification: NSNotification) {
        let alertView = CustomAlertView(title: L10n.Settings.signout, description: L10n.Settings.Signout.description, mainButtonHandler: logout)
        
        view.addSubview(alertView)
        
        let constraints = [
            alertView.topAnchor.constraint(equalTo: view.topAnchor),
            alertView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - MetroStartViewDelegate
extension HomeViewController: MetroStartViewDelegate {
    func tileItemHasSelected(operation: OperationWeb) {
        showDesktopApplication(externalOperationWebView: operation)
    }
}
