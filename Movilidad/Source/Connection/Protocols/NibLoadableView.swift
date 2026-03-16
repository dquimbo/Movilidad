//
//  NibLoadableView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/2/22.
//

import UIKit

protocol NibLoadableView: UIView {}

extension NibLoadableView {
    static var nibName: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: Self.nibName, bundle: Bundle(for: Self.self))
    }

    static func loadFromNib() -> UIView {
        return Self.nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
