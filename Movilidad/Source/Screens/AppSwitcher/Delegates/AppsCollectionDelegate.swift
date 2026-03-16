//
//  AppsCollectionDelegate.swift
//  Movilidad
//
//  Created by Diego Quimbo on 9/3/22.
//

import UIKit

class AppsCollectionDelegate: NSObject, UICollectionViewDelegate {
    // MARK: - Properties
    unowned var controller: AppSwitcherViewController

    // MARK: - Initializer
    init(controller: AppSwitcherViewController) {
        self.controller = controller
    }
    
    // MARK: - Delegate Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.delegate?.switchAppHasSelected(index: indexPath.row)
    }
}
