//
//  AppSwitcherViewController.swift
//  Movilidad
//
//  Created by Diego Quimbo on 2/3/22.
//

import UIKit

protocol AppSwitcherViewControllerDelegate: AnyObject {
    func switchAppHasSelected(index: Int)
    func switchAppHasClosed(accessibilityIdentifier: String)
}

class AppSwitcherViewController: UIViewController, NibLoadable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var appsCollectionView: UICollectionView! {
        didSet {
            appsCollectionView.dataSource = collectionAppsDataSource
            appsCollectionView.delegate = collectionAppsDelegate
            appsCollectionView.backgroundColor = .clear
            appsCollectionView.register(AppPreviewCell.nib,
                                     forCellWithReuseIdentifier: AppPreviewCell.reuseIdentifier)
        }
    }
    
    // Public Properties
    let vM: AppSwitcherViewModel
    var router: AppSwitcherRouter?
    weak var delegate: AppSwitcherViewControllerDelegate?
    
    // Private Properties
    private var collectionAppsDataSource: AppsCollectionDataSource?
    private var collectionAppsDelegate: AppsCollectionDelegate?

    required init(viewModel: AppSwitcherViewModel) {
        self.vM = viewModel
        super.init(nibName: AppSwitcherViewController.nibName, bundle: AppSwitcherViewController.bundle)
        
        self.router = .init(controller: self)
        self.collectionAppsDataSource = .init(controller: self)
        self.collectionAppsDelegate = .init(controller: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func pressedClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - AppPreviewCellDelegate
extension AppSwitcherViewController: AppPreviewCellDelegate {
    func closeAppPreviewHasPressed(accessibilityIdentifier: String) {        
        delegate?.switchAppHasClosed(accessibilityIdentifier: accessibilityIdentifier)
        
        vM.removeApp(id: accessibilityIdentifier)
        appsCollectionView.reloadData()
    }
}
