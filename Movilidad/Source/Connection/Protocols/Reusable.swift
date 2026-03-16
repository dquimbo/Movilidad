//
//  Reusable.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/2/22.
//

import UIKit

protocol Reusable: AnyObject {}

extension Reusable where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
