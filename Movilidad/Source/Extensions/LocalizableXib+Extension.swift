//
//  LocalizableXib+Extension.swift
//  Movilidad
//
//  Created by Diego Quimbo on 13/1/22.
//

import UIKit

/// implement the Localized version of all objects used in this app

public protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension String {
    
    /// - Returns: localized version of the String
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

extension UILabel: XIBLocalizable {

    /// - Returns: localized version of the UILabel
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized()
        }
    }
}

extension UIButton: XIBLocalizable {
    
    /// - Returns: localized version of the UIButton
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized(), for: .normal)
        }
    }
}

public protocol UITextFieldXIBLocalizable {
    var xibPlaceholderLocKey: String? { get set }
}

extension UITextField: UITextFieldXIBLocalizable {
    
    /// - Returns: localized version of the UITextField
    @IBInspectable public var xibPlaceholderLocKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized()
        }
    }
}

extension UITextView: XIBLocalizable {
    
    /// - Returns: localized version of the UITextView
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized()
        }
    }
}

public protocol UITextFieldWithTitleXIBLocalizable {
    var xibTitleLocKey: String? { get set }
    var xibPlaceholderLocKey: String? { get set }
}
