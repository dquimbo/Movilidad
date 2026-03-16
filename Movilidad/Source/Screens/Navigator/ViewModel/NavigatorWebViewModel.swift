//
//  NavigatorWebViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 11/9/23.
//

import Foundation
import UIKit

final class NavigatorWebViewModel {
    
    func buildUrl(urlString: String?) -> URL? {
        guard let address = urlString, verifyUrl(urlString: address) else {
            return nil
        }
        
        return URL(string: address)
    }
}

// MARK: - Private Functions
private extension NavigatorWebViewModel {
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
