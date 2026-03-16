//
//  Double+Extension.swift
//  Movilidad
//
//  Created by Diego Quimbo on 9/5/23.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
