//
//  AppSwitcherViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 2/3/22.
//

import Foundation
import UIKit

final class AppSwitcherViewModel {
    private var appsSwitcher: [AppSwitcher]
    
    init(appsSwitcher: [AppSwitcher]) {
        self.appsSwitcher = appsSwitcher
    }
    
    func getNumberOfRows() -> Int {
        return appsSwitcher.count
    }
    
    func getAppSwitcherItem(index: Int) -> AppSwitcher {
        return appsSwitcher[index]
    }
    
    func removeApp(id: String) {
        appsSwitcher.removeAll(where: {$0.accessibilityIdentifier == id})
    }
}
