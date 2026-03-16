//
//  MetroDesktopView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 29/9/23.
//

import UIKit
import RxSwift

protocol MetroDesktopViewDelegate: AnyObject {
    func tileItemHasSelected(operation: OperationWeb)
}

class MetroDesktopView: NibLoadingView {
    
    // IBOutlets
    @IBOutlet weak var tilesCollectionView: UICollectionView! {
        didSet {
            tilesCollectionView.registerReusableCell(TileCollectionViewCell.self)
            tilesCollectionView.dataSource = self
            tilesCollectionView.delegate = self
        }
    }
    
    // Public Properties
    weak var delegate: MetroDesktopViewDelegate?
    
    // Private Properties
    private let vM: MetroDesktopViewModel
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    required init(guid: String, frame: CGRect, delegate: MetroDesktopViewDelegate) {
        self.vM = .init(guid: guid)
        self.delegate = delegate
        
        super.init(frame: frame)
        
        loadTiles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    @IBAction func closePressed(_ sender: Any) {
        removeFromSuperview()
    }
}

// MARK: - UICollectionViewDataSource
extension MetroDesktopView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vM.tiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCollectionViewCell", for: indexPath) as! TileCollectionViewCell
        
        cell.configureCell(tileOperation: vM.tiles[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navigationURL = vM.tiles[indexPath.row].navigationString else { return }
        
        let operationURL = "\(URLs.baseURL())\(navigationURL)"
        
        let operationWeb = OperationWeb(externalURL: operationURL)
        
        delegate?.tileItemHasSelected(operation: operationWeb)
    }
}

private extension MetroDesktopView {
    func loadTiles() {
        showProgressHud(view: self, text: L10n.Metro.Desktop.Loading.tiles)
        
        vM.getTiles()
            .subscribe { [weak self] in
                guard let self = self else { return }
                
                self.hideProgressHud(view: self)

                self.tilesCollectionView.reloadData()
                
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                
                self.hideProgressHud(view: self)
                
                self.showAlert(title: L10n.General.Error.title, message: L10n.Metro.Desktop.Empty.tiles)
            }.disposed(by: disposeBag)
    }
}
