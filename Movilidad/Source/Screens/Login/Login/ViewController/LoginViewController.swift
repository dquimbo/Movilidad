//
//  LoginViewController.swift
//  DemoMovilidad-UK
//
//  Created by Diego Quimbo on 4/1/22.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController, NibLoadable {

    // IBOutlets
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.isEnabled = true
        }
    }
    
    @IBOutlet weak var slideSettingsView: LoginSettingsView!
    @IBOutlet weak var slideTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorContentView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var serverButton: UIButton!
    
    // Properties
    let vM: LoginViewModel
    var router: LoginRouter?
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    required init(viewModel: LoginViewModel) {
        self.vM = viewModel
        super.init(nibName: LoginViewController.nibName, bundle: LoginViewController.bundle)
        
        self.router = .init(controller: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        if #available(iOS 14.0, *) {
            LocalNetworkAuthorization().requestAuthorization()
        }
    }
    
    // MARK: - IBActions
    @IBAction func loginPressed(_ sender: Any) {
        activityIndicator.isHidden = false

        let user = userTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        vM.signIn(user: user, password: password)
            .subscribe { [weak self] loginError in

                guard let error = loginError else {
                    self?.showGenericError()
                    return
                }

                self?.handleLoginResponse(user: user, password: password, error: error)
            } onFailure: { [weak self] _ in
                self?.showGenericError()
            }.disposed(by: disposeBag)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        // If slideTrailing is > 0 means that the slide is close
        // If slideTrailing is 0 means that the slide is open
        slideSettingsMove(open: slideTrailingConstraint.constant > 0)
    }
    
    @IBAction func serverPressed(_ sender: Any) {
        settingsPressed(sender)
    }
    
    @IBAction func errorDetailPressed(_ sender: Any) {
        
        router?.route(route: .loginErrorDetail)
    }
}

// MARK: - Private Functions
private extension LoginViewController {
    func setupView() {
        // Bind activityIndicator and wait for events
        vM.hideLoading.asObservable().observe(on: MainScheduler.instance).bind(to: activityIndicator.rx.isHidden).disposed(by: disposeBag)
        
        // If there was previous login, fill the username with the latest user credentials
        let credentials = Keychain.shared.getUserCredentials()
        if let username = credentials?.user {
            userTextField.text = username
        }
        
        setupSlideSettings()
        setUpTextChangeHandling()
    }
    
    func setupSlideSettings() {
        slideSettingsView.setupView(delegate: self)
        
        // Hide Slide Settings
        slideTrailingConstraint.constant = slideSettingsView.frame.width
        view.layoutIfNeeded()
    }
    
    func slideSettingsMove(open: Bool) {
        slideTrailingConstraint.constant = open ? 0 : slideSettingsView.frame.width
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setUpTextChangeHandling() {
        // Valid fields to enable confirm button
        let userValid = userTextField
            .rx
            .text
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { !($0?.isEmpty ?? true) }
        
        let passwordValid = passwordTextField
            .rx
            .text
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { !($0?.isEmpty ?? true) }

        let everythingValid = Observable
            .combineLatest(userValid, passwordValid) {
                $0 && $1
        }

        everythingValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func handleLoginResponse(user: String, password: String, error: ServiceError) {
        if error.error == nil && error.serverError == nil {
            // Login Success
            vM.saveCredentials(user: user, password: password)
            clearTextfields()
            
            router?.route(route: .home)
        } else {
            // There was an error, try to get a friendly error
            errorContentView.isHidden = false
            guard let friendlyMessage = error.friendlyError else {
                errorLabel.text = L10n.General.Error.connection
                return
            }
            
            errorLabel.text = friendlyMessage
        }
    }
    
    func showGenericError() {
        errorContentView.isHidden = false
        errorLabel.text = L10n.General.Error.connection
    }
    
    func clearTextfields() {
        passwordTextField.text = ""
    }
}

// MARK: - LoginSettingsViewDelegate Functions
extension LoginViewController: LoginSettingsViewDelegate {
    func cancelPressed() {
        // Close slide
        slideSettingsMove(open: false)
    }
    
    func addServerPressed() {
        showInputDialog(title: L10n.LoginSetting.Add.Server.title,
                        subtitle: L10n.LoginSetting.Add.Server.description,
                        actionTitle: L10n.General.accept,
                        cancelTitle: L10n.General.cancel,
                        inputKeyboardType: .URL,
                        actionHandler:{ [weak self] (url: String?) in
            SettingsHandler.shared.saveServer(url: url)
            self?.vM.serverSelectedHasChanged()
            self?.slideSettingsView.refreshServerList()
        })
    }
    
    func removeServerPressed(url: String) {
        let alert = UIAlertController(title: L10n.LoginSetting.Remove.Server.title, message: "\(L10n.LoginSetting.Remove.Server.description) \(url)?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: L10n.General.delete, style: .default, handler: {_ in
            SettingsHandler.shared.deleteServer(url: url)
            self.slideSettingsView.refreshServerList()
        })
        
        alert.addAction(delete)
        alert.addAction(UIAlertAction(title: L10n.General.cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func networkToolPressed() {
        router?.route(route: .networkTool)
    }
}
