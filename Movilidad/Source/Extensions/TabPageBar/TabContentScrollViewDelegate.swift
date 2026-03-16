//
//  TabContentScrollViewDelegate.swift
//  Movilidad
//
//  Created by Diego Quimbo on 31/1/22.
//

import UIKit

internal protocol TabContentScrollViewDelegate {
    func tabContentViewDidScroll(_ scrollView: UIScrollView)
    func tabContentViewDidEndDecelerating(_ scrollView: UIScrollView)
    func tabContentViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
}
