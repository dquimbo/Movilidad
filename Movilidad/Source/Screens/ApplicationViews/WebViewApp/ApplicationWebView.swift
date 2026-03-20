//
//  ApplicationWebView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 21/2/22.
//

import UIKit
@preconcurrency import WebKit
import RxSwift
import PhotosUI

protocol ApplicationWebViewDelegate: AnyObject {
    func show(controller: UIViewController)
    func showPlayer(videoPath: String)
    func webViewTapRecognizer()
    func openNewWebOperation(url: String)
    func updateNotificationsCount(count: Int?)
}

class ApplicationWebView: NibLoadingView {
    // IBOutlets
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
//            webView.customUserAgent = registerUserAgent()
        }
    }
    
    // Public Properties
    weak var delegate: ApplicationWebViewDelegate?
    
    // Private Properties
    private let vM: ApplicationWebViewViewModel
    private var loadCount: Int = 0
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    required init(operationInfo: OperationWeb, delegate: ApplicationWebViewDelegate?) {
        vM = .init(operationInfo: operationInfo)
        
        super.init(frame: .zero)
        
        self.delegate = delegate
        self.accessibilityIdentifier = UUID().uuidString
        
        // It's necessary set the tag in order to find the subview reference in DesktopContentAppView
        self.tag = 1
        
        setupView()
        
        print("Profile name: \(SessionManager.shared.profile?.profileSelectedGuid)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func reloadViewInScroll() {
        super.reloadViewInScroll()
        webView.layoutIfNeeded()
    }
    
    // MARK: - Public Functions
    public func reloadApplicationView() {
        webView.reload()
    }
    
    // MARK: - Private Functions
    private func setupView() {
        // Load storage cookies in WKWebView
        loadPreviousCookies()

        configureCredentials(host: vM.url.host)

        showProgressHud(view: self, text: L10n.General.Loading.app)

        let request = URLRequest(url: vM.url)
        webView.load(request)

        // This tap gesture is used in order to hide the slide menu when the user tap outside of it
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(webViewTapRecognizer))
        tapGesture.delegate = self
        webView.addGestureRecognizer(tapGesture)

        if SessionManager.shared.profile?.profileSelectedGuid == "3D34EDB4-3EC2-473E-8B68-8795D55272BE" {
            setupFloatingButton()
        }
    }
    
    private func registerUserAgent() -> String {
        let deviceType = UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
        
        return "Mozilla/5.0 (\(deviceType); CPU OS 6_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B141 Safari/8536.25 MdwClient-iPad MdwDevice-Tablet"
        
    }
    
    @objc func webViewTapRecognizer() {
        delegate?.webViewTapRecognizer()
    }
}

// MARK: - WKNavigationDelegate
extension ApplicationWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        guard !vM.checkIfIsOpenMultipleOperations(url: url)  else {
            guard let URLs = vM.getMultipleOperationsURLs(url: url) else {
                decisionHandler(.allow)
                return
            }
            
            for urlNewOperation in URLs {
                delegate?.openNewWebOperation(url: urlNewOperation)
            }
            
            decisionHandler(.cancel)
            
            return
        }
        
        guard navigationAction.request.url?.scheme == "mdwfunctions"  else {
            if vM.checkIfIsOpenNewWebView(url: url) {
                guard let url = vM.buildExternalUrl(url: url) else {
                    decisionHandler(.allow)
                    return
                }
                
                delegate?.openNewWebOperation(url: url)
                
                decisionHandler(.cancel)
                return
            }
            
            decisionHandler(.allow)
            return
        }
        
        switch vM.handleWebInteropAction(url: url) {
        case .camera:
            openCamera(withVideo: false)
        case .galeryMultiple:
            if #available(iOS 14.0, *) {
                showMultipleMediaPicker(onlyVideos: false)
            }
        case .videocamera:
            openCamera(withVideo: true)
        case .videogalery:
            if #available(iOS 14.0, *) {
                showMultipleMediaPicker(onlyVideos: true)
            }
        case .recordaudio:
            showRecordAudioScreen()
        case .barcode:
            showBarcode()
        case .videogalerychunck:
            processVideoGaleryChunck()
        case .videoremovetemp:
            webView.reload()
        case .playVideo:
            playVideoInterop()
        case .playAudio:
            playAudioInterop()
        case .notificationRegister:
            handleNotificationRegister(url: url)
        case .updateNotificationCount:
            delegate?.updateNotificationsCount(count: vM.updateNotificationCount)
        default:
            break
        }
        
        decisionHandler(.cancel)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            guard let serverTrust = challenge.protectionSpace.serverTrust else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            
            let cred = URLCredential(trust: serverTrust)
            
            challenge.sender?.use(URLCredential(trust: serverTrust), for: challenge)
            challenge.sender?.continueWithoutCredential(for: challenge)
            
            completionHandler(.useCredential, URLCredential(trust: serverTrust));
            
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM ||
                    challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic ||
                    challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNegotiate {
            
            let credentials = Keychain.shared.getUserCredentials()
            guard let user = credentials?.user,
                  let userPassword = credentials?.password else {
                return
            }
            
            let userLogin = "TERNIUM\\\(user)"
            
            let credential = URLCredential(user: userLogin,
                                           password: userPassword,
                                           persistence: .forSession)
            
            challenge.sender?.use(credential, for: challenge)
            
            completionHandler(.useCredential, credential);
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadCount += 1
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadCount -= 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            if self?.loadCount == 0 {
                guard let self = self else { return }
                self.hideProgressHud(view: self)
            }
        }
        
        let jsInjection = "window.open = function (url, d1, d2) { window.location = \"open:\" + d1 + \":\" + url; };"
        webView.evaluateJavaScript(jsInjection)
    }
}

// MARK: - Interop Take Photo
extension ApplicationWebView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func openCamera(withVideo: Bool) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        
        if withVideo {
            imagePickerController.mediaTypes = ["public.movie"]
        }
        
        delegate?.show(controller: imagePickerController)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else { return }
        
        if mediaType  == "public.image" {
            let imageSelected = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            processImage(imageSelected: imageSelected)
        }
        
        if mediaType == "public.movie" {
            processVideo(info: info)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func processImage(imageSelected: UIImage) {
        guard let newScript = vM.processImage(image: imageSelected) else { return }
        
        webView.evaluateJavaScript(newScript)
    }
}

// MARK: - Interop Video Camera
private extension ApplicationWebView {
    func processVideo(info: [UIImagePickerController.InfoKey : Any]) {
        guard let newScript = vM.processVideo(info: info) else { return }
        
        webView.evaluateJavaScript(newScript)
    }
    
    func processVideoGaleryChunck() {
        guard let newScript = vM.processVideoGaleryChunck() else { return }
        
        webView.evaluateJavaScript(newScript)
    }
    
    func playVideoInterop() {
        showProgressHud(view: self)
        
        vM.downloadVideoFile()
            .subscribe { [weak self] videoURL in
                guard let self = self,
                      let videoPath = videoURL else { return }
                
                self.delegate?.showPlayer(videoPath: videoPath)
                
                self.hideProgressHud(view: self)
            } onFailure: { [weak self] _ in
                guard let self = self else { return }
                self.showAlert(title: L10n.General.Error.title, message: L10n.Video.Download.error)
                
                self.hideProgressHud(view: self)
            }.disposed(by: disposeBag)
    }
    
    func playAudioInterop() {
        showProgressHud(view: self)
        
        vM.downloadAudioFile()
            .subscribe { [weak self] videoURL in
                guard let self = self,
                      let videoPath = videoURL else { return }
                
                self.delegate?.showPlayer(videoPath: videoPath)
                
                self.hideProgressHud(view: self)
            } onFailure: { [weak self] _ in
                guard let self = self else { return }
                self.showAlert(title: L10n.General.Error.title, message: L10n.Video.Download.error)
                
                self.hideProgressHud(view: self)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Interop Take Photo
@available(iOS 14.0, *)
extension ApplicationWebView: PHPickerViewControllerDelegate {
    private func showMultipleMediaPicker(onlyVideos: Bool) {
        var config = PHPickerConfiguration()
        config.selectionLimit = onlyVideos ? 1 : 10
        config.filter = onlyVideos ? PHPickerFilter.any(of: [.videos]) : PHPickerFilter.any(of: [.images, .livePhotos])
        
        let phPickerViewController = PHPickerViewController(configuration: config)
        phPickerViewController.delegate = self
        delegate?.show(controller: phPickerViewController)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        showProgressHud(view: view, text: L10n.Home.Loading.profile)
        
        for result in results {
            guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
                showAlert(title: L10n.General.Error.title, message: L10n.Video.Load.error)
                return
            }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage {
                    guard let newScript = self?.vM.processImage(image: image) else { return }
                    
                    DispatchQueue.main.async {
                        self?.webView.evaluateJavaScript(newScript)
                    }
                }
            }
                        
            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { videoURL, error in
                    if let url = videoURL {
                        guard let newScript = self.vM.processVideoFromLibrary(source: url) else { return }

                        DispatchQueue.main.async {
                            self.webView.evaluateJavaScript(newScript)
                        }
                    }
                }
            }
        }
        
        self.hideProgressHud(view: self.view)
    }
}

// MARK: - Interop record audio
private extension ApplicationWebView {
    func showRecordAudioScreen() {
        let recorderView = RecorderView(codec: vM.codecAudioRecording, delegate: self)
        
        view.addSubview(recorderView)
        
        let constraints = [
            recorderView.topAnchor.constraint(equalTo: view.topAnchor),
            recorderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            recorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - Barcode
private extension ApplicationWebView {
    func showBarcode() {
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
        guard let newScript = vM.processBarcode(code: code) else { return }
        
        webView.evaluateJavaScript(newScript)
    }
}

// MARK: - Private Functions
private extension ApplicationWebView {
    func loadPreviousCookies() {
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        for cookie in cookies {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
    }
    
    func configureCredentials(host: String?) {
        let credentials = Keychain.shared.getUserCredentials()
        guard let user = credentials?.user,
              let userPassword = credentials?.password,
              let server = host else {
            return
        }
        
        let userLogin = "TERNIUM\\\(user)"
        
        let credential = URLCredential(user: userLogin,
                                       password: userPassword,
                                       persistence: .forSession)
        
        // APC Credentials
        let protectionSpaceAPC = URLProtectionSpace(host: server,
                                                    port: 433,
                                                    protocol: "https",
                                                    realm: "apc.ternium.com",
                                                    authenticationMethod: NSURLAuthenticationMethodDefault)
        
        URLCredentialStorage.shared.set(credential, for: protectionSpaceAPC)
        
        // Mobile Credentials
        let protectionSpaceMobile = URLProtectionSpace(host: server,
                                                       port: 443,
                                                       protocol: "https",
                                                       realm: "mobile.ternium.com",
                                                       authenticationMethod: NSURLAuthenticationMethodDefault)
        
        URLCredentialStorage.shared.set(credential, for: protectionSpaceMobile)
        
        let protectionSpace443 = URLProtectionSpace(host: server,
                                                   port: 443,
                                                   protocol: "https",
                                                   realm: host,
                                                   authenticationMethod: NSURLAuthenticationMethodDefault)
        
        URLCredentialStorage.shared.set(credential, for: protectionSpace443)
        
        let protectionSpace80 = URLProtectionSpace(host: server,
                                                   port: 80,
                                                   protocol: "http",
                                                   realm: host,
                                                   authenticationMethod: NSURLAuthenticationMethodDefault)
        
        URLCredentialStorage.shared.set(credential, for: protectionSpace80)
    }
}

// MARK: - Notifications
private extension ApplicationWebView {
    func handleNotificationRegister(url: URL) {
        guard let newScript = vM.processRegisterNotification(url: url) else { return }
        
        webView.evaluateJavaScript(newScript)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ApplicationWebView:  UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - RecorderViewDelegate
extension ApplicationWebView: RecorderViewDelegate {
    func uploadAudioFile(audioPath: URL) {
        guard let newScript = vM.processRecordAudio(audioPath: audioPath) else { return }

        webView.evaluateJavaScript(newScript)
    }
}

// MARK: - Floating Button & Popup WebView
private extension ApplicationWebView {
    func setupFloatingButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "globe"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = Asset.buttonBackground.color
        button.layer.cornerRadius = 28
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(floatingButtonPressed), for: .touchUpInside)

        addSubview(button)

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 56),
            button.heightAnchor.constraint(equalToConstant: 56),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)
        ])
    }

    @objc func floatingButtonPressed() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        let popupView = WebPopupView(url: URL(string: "https://ternium-non-prod-8il0jhic.us21.sapdas.cloud.sap/webclient/standalone/sap_digital_assistant")!)
        window.addSubview(popupView)

        NSLayoutConstraint.activate([
            popupView.topAnchor.constraint(equalTo: window.topAnchor),
            popupView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            popupView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            popupView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
    }
}

// MARK: - WebPopupView
class WebPopupView: UIView, WKNavigationDelegate {

    private let popupWebView: WKWebView
    private var container: UIView!
    private var loadCount: Int = 0

    required init(url: URL) {
        popupWebView = WKWebView(frame: .zero)
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black.withAlphaComponent(0.5)

        setupUI()
        loadPreviousCookies()

        popupWebView.navigationDelegate = self
        showProgressHud(view: container, text: L10n.General.Loading.app)
        popupWebView.load(URLRequest(url: url))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Container with rounded corners
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        addSubview(container)

        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .darkGray
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        container.addSubview(closeButton)

        // WebView
        popupWebView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(popupWebView)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            container.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),

            popupWebView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 4),
            popupWebView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            popupWebView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            popupWebView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }

    @objc private func closeTapped() {
        removeFromSuperview()
    }

    private func loadPreviousCookies() {
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        for cookie in cookies {
            popupWebView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
    }

    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadCount += 1
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadCount -= 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            if self.loadCount == 0 {
                self.hideProgressHud(view: self.container)
            }
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadCount -= 1
        hideProgressHud(view: container)
        showAlert(title: L10n.General.Error.title, message: error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadCount -= 1
        hideProgressHud(view: container)
        showAlert(title: L10n.General.Error.title, message: L10n.Navigator.generalError2)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        if let response = navigationResponse.response as? HTTPURLResponse {
            if response.statusCode != 200 {
                showAlert(title: L10n.General.Error.title, message: L10n.Navigator.urlStatusCode("\(response.statusCode)"))
            }
        }
        
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    }
}
