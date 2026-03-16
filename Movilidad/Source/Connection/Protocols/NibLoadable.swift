//
//  NibLoadable.swift
//  DemoMovilidad-UK
//
//  Created by Diego Quimbo on 4/1/22.
//

import UIKit

protocol NibLoadable: AnyObject {}

extension NibLoadable where Self: UIViewController {
    static var nibName: String {
        return String(describing: self)
    }

    static var bundle: Bundle {
        return Bundle(for: self)
    }
}
