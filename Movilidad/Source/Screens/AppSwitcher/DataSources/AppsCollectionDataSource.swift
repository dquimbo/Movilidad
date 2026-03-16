//
//  AppsCollectionDataSource.swift
//  Movilidad
//
//  Created by Diego Quimbo on 8/3/22.
//

import UIKit

class AppsCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    unowned var controller: AppSwitcherViewController

    // MARK: - Initializer
    init(controller: AppSwitcherViewController) {
        self.controller = controller
    }

    // MARK: - DataSource Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller.vM.getNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppPreviewCell.reuseIdentifier, for: indexPath) as? AppPreviewCell else {
            return UICollectionViewCell()
        }
        
        let appSwitcher = controller.vM.getAppSwitcherItem(index: indexPath.row)
        let cellViewModel = AppPreviewCellViewModel(appSwitcher: appSwitcher)
        cell.configure(viewModel: cellViewModel)
        cell.delegate = controller
        
        return cell
    }
}
