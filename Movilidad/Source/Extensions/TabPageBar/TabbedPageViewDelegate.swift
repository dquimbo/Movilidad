//
//  TabbedPageViewDelegate.swift
//  Movilidad
//
//  Created by Diego Quimbo on 31/1/22.
//

import UIKit

public protocol TabbedPageViewDelegate: AnyObject {
    func tabbedPageView(_ tabbedPageView: TabbedPageView, didSelectTabAt index: Int)
}

public extension TabbedPageViewDelegate {
    func tabbedPageView(_ tabbedPageView: TabbedPageView, didSelectTabAt index: Int) {
        return
    }
}
