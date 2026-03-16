//
//  AppPreviewCellViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 8/3/22.
//

import UIKit

class AppPreviewCellViewModel {
    // MARK: - Properties
    private let appSwitcher: AppSwitcher
    
    // MARK: - Initializer
    init(appSwitcher: AppSwitcher) {
        self.appSwitcher = appSwitcher
    }
    
    // MARK: - Properties
    var title: String {
        return appSwitcher.title
    }
    
    var backgroundImage: UIImage {
        return appSwitcher.backgroundImage
    }
    
    var hiddenTopBar: Bool {
        return !appSwitcher.topBarIsNeeded
    }
    
    var accessibilityIdentifier: String? {
        return appSwitcher.accessibilityIdentifier
    }
}
