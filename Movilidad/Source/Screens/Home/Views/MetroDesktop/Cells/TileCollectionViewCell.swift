//
//  TileCollectionViewCell.swift
//  Movilidad
//
//  Created by Diego Quimbo on 9/10/23.
//

import UIKit
import WebKit

class TileCollectionViewCell: UICollectionViewCell, Reusable {
    
    // IBOutlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var tile: Tile?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 2
        layer.borderColor = Asset.borderViews.color.cgColor
    }
    
    // MARK: - Public Methods
    func configureCell(tileOperation: Tile) {
        tile = tileOperation
        
        if let previewURL = tileOperation.previewString, !previewURL.isEmpty {
            loadPreview(previewURL: previewURL)
        } else {
            webView.isHidden = true
        }
        
        titleLabel.text = tile?.title
    }
}

// MARK: - Private Methods
private extension TileCollectionViewCell {
    func loadPreview(previewURL: String) {
        // Load storaged cookies in WKWebView
        loadPreviousCookies()
        
        guard let fragmentedURL = previewURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
              let url = URL(string: fragmentedURL) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        loadCredentials(host: url.host)
        
        webView.load(request)
    }
    
    func loadPreviousCookies() {
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        for cookie in cookies {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
    }
    
     func loadCredentials(host: String?) {
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
        
        let protectionSpace = URLProtectionSpace(host: server,
                                                 port: 80,
                                                 protocol: "http",
                                                 realm: host,
                                                 authenticationMethod: NSURLAuthenticationMethodDefault)
        
        URLCredentialStorage.shared.set(credential, for: protectionSpace)
    }
}
