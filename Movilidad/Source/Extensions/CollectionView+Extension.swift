//
//  CollectionView+Extension.swift
//  Movilidad
//
//  Created by Diego Quimbo on 9/10/23.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        self.register(UINib.init(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't dequeue cell with identifier \(T.reuseIdentifier)")
        }
        return cell
    }
    
}
