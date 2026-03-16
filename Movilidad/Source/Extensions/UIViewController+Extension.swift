//
//  UIViewController+Extension.swift
//  DemoMovilidad-UK
//
//  Created by Diego Quimbo on 4/1/22.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showProgressHud(view: UIView, text: String = "") {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.label.text = text
    }
    
    func hideProgressHud(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showAlertWithHandler(title: String,
                              message: String,
                              actionTitle:String? = L10n.General.accept,
                              cancelTitle:String? = L10n.General.cancel,
                              actionHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: actionHandler))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = L10n.General.accept,
                         cancelTitle:String? = L10n.General.cancel,
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}

