//
//  StandarButton.swift
//  Movilidad
//
//  Created by Diego Quimbo on 21/1/22.
//

import UIKit

class StandarButton: UIButton {

    override public var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
            } else {
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.5)
            }
        }
    }

}
