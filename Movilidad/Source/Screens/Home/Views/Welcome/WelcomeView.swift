//
//  WelcomeView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 15/2/22.
//

import UIKit
import RxSwift

protocol WelcomeViewDelegate: AnyObject {
    func favoriteOperationHasSelected(operation: OperationItem)
    func searchedOperationHasSelected(operation: OperationItem)
    func changeProfileHasPressed(source: UIView)
}

class WelcomeView: NibLoadingView {
    // IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessProfileLabel: UILabel!
    @IBOutlet weak var topBarFavoritesView: UIView!
    @IBOutlet weak var topBarGeneralSearchView: UIView!
    @IBOutlet weak var appInfoLabel: UILabel!
    @IBOutlet weak var serverLabel: UILabel!
    
    @IBOutlet weak var generalSearchBar: UISearchBar! {
        didSet {
            generalSearchBar.delegate = self
            if #available(iOS 13.0, *) {
                generalSearchBar.searchTextField.textColor = .black
            }
        }
    }
    
    @IBOutlet weak var favoritesAppsTableView: UITableView! {
        didSet {
            favoritesAppsTableView.separatorStyle = .none
            favoritesAppsTableView.backgroundColor = UIColor.white
            favoritesAppsTableView.register(FavoriteAppCell.nib,
                               forCellReuseIdentifier: FavoriteAppCell.reuseIdentifier)
        }
    }
    
    @IBOutlet weak var generalSearchTableView: UITableView! {
        didSet {
            generalSearchTableView.separatorStyle = .none
            generalSearchTableView.backgroundColor = UIColor.white
            generalSearchTableView.register(GeneralSearchCell.nib,
                               forCellReuseIdentifier: GeneralSearchCell.reuseIdentifier)
        }
    }
    
    // Public Properties
    let vM: WelcomeViewModel = .init()
    weak var delegate: WelcomeViewDelegate?
    
    // Private Properties
    private var favoriteAppsDelegate: FavoriteAppsTableDelegate?
    private var favoriteAppsDataSource: FavoriteAppsTableDataSource?
    private var generalSearchDataSource: GeneralSearchTableDataSource?
    private var generalSearchDelegate: GeneralSearchTableDelegate?
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.favoriteAppsDataSource = .init(controller: self)
        self.favoriteAppsDelegate = .init(controller: self)
        self.generalSearchDataSource = .init(controller: self)
        self.generalSearchDelegate = .init(controller: self)
        
        favoritesAppsTableView.dataSource = favoriteAppsDataSource
        favoritesAppsTableView.delegate = favoriteAppsDelegate
        
        generalSearchTableView.dataSource = generalSearchDataSource
        generalSearchTableView.delegate = generalSearchDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Functions
    func refreshData() {
        setupView()
    }
    
    // MARK: - Private Functions
    private func setupView() {
        nameLabel.text = vM.username
        titleLabel.text = vM.titleProfile
        accessProfileLabel.text = vM.profileDescription
        
        topBarFavoritesView.roundCorners(radius: 5.0, corners: [.topLeft, .topRight])
        topBarGeneralSearchView.roundCorners(radius: 5.0, corners: [.topLeft, .topRight])
        
        appInfoLabel.text = vM.appInfo
        serverLabel.text = vM.currentServer
        
        favoritesAppsTableView.reloadData()
        generalSearchTableView.reloadData()
        
        getProfilePhoto()
    }
    
    // MARK: - IBActions
    @IBAction func closeSession(_ sender: Any) {
        NotificationCenter.default.post(name: .logout, object: nil, userInfo: nil)
    }
    
    @IBAction func showProfiles(_ sender: Any) {
        guard let button = sender as? UIButton, UIDevice.current.userInterfaceIdiom == .pad else { return }
        
        delegate?.changeProfileHasPressed(source: button)
    }
    
    // MARK: - Private functions
    private func getProfilePhoto() {
        vM.getProfilePhoto()
            .subscribe { [weak self] photoData in
                guard let self = self,
                      let profilePhotoData = photoData,
                      let profileImage = UIImage(data: profilePhotoData) else { return }
                
                profileImageView.image = profileImage
            }.disposed(by: disposeBag)
    }
}

extension WelcomeView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vM.updateFilteredMenuItems(searchText: searchText)
        generalSearchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
