//
//  UInavigationController+Extension.swift
//  Movilidad
//
//  Created by Diego Quimbo on 10/2/22.
//

import UIKit

extension UINavigationController {
    var rootViewController : UIViewController? {
        return viewControllers.first
    }
}
