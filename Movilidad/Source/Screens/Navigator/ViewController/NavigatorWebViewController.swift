//
//  NavigatorWebViewController.swift
//  Movilidad
//
//  Created by Diego Quimbo on 11/9/23.
//

import UIKit
import WebKit

class NavigatorWebViewController: UIViewController, NibLoadable {
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    // Properties
    private let vM: NavigatorWebViewModel
    private var router: NavigatorWebRouter?

    // MARK: - Life Cycle
    required init(viewModel: NavigatorWebViewModel) {
        self.vM = viewModel
        super.init(nibName: NavigatorWebViewController.nibName, bundle: NavigatorWebViewController.bundle)
        
        self.router = .init(controller: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load storaged cookies in WKWebView
        loadPreviousCookies()
    }
    
    // MARK: - IBActions
    @IBAction func closePressed(_ sender: Any) {
        router?.route(route: .back)
    }
    
    @IBAction func goPressed(_ sender: Any) {
        loadWebView()
    }
}

// MARK: - private Functions
private extension NavigatorWebViewController {
    
    func loadWebView() {
        guard let url = vM.buildUrl(urlString: addressTextField.text) else {
            showAlert(title: L10n.General.Error.title, message: L10n.Navigator.noValidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func loadPreviousCookies() {
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        for cookie in cookies {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
    }
}

extension NavigatorWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        if let response = navigationResponse.response as? HTTPURLResponse {
            if response.statusCode != 200 {
                showAlert(title: L10n.General.Error.title, message: L10n.Navigator.urlStatusCode("\(response.statusCode)"))
            }
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showAlert(title: L10n.General.Error.title, message: L10n.Navigator.generalError(error.localizedDescription))
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showAlert(title: L10n.General.Error.title, message: L10n.Navigator.generalError2)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust));
    }
}
