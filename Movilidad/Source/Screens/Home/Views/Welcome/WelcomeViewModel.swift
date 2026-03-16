//
//  WelcomeViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 16/2/22.
//

import Foundation
import RxSwift
import RxCocoa

final class WelcomeViewModel {
    
    // Private Vars
    private var filteredMenuItems: [OperationItem] = []
    private let profileService = ConnectionManager_Profile()
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // MARK: - Public Vars
    var username: String {
        return SessionManager.shared.profile?.additionalProfileInfo?.displayName ?? ""
    }
    
    var titleProfile: String {
        return SessionManager.shared.profile?.additionalProfileInfo?.title ?? ""
    }
    
    var profileDescription: String {
        return SessionManager.shared.profile?.profileSelected?.descripcion ?? ""
    }
    
    var appInfo: String {
        let appVersion = SettingsHandler.shared.appInfo.version
        let build = SettingsHandler.shared.appInfo.build
        
        let buildDate = Utilities.formatDate(format: "EE MMM dd hh:MM - MM YYYY",
                                             date: SettingsHandler.shared.appInfo.buildDate)
        
        return L10n.Home.App.info(appVersion, build, buildDate)
    }
    
    var currentServer: String {
        return SettingsHandler.shared.serverSelected
    }
    
    // MARK: - Public Functions
    func getNumberOfFavoriteOperations() -> Int {
        return SessionManager.shared.getFavoriteOperations().count
    }
    
    func getFavoriteOperationByIndex(index: Int) -> OperationItem {
        return SessionManager.shared.getFavoriteOperations()[index]
    }
    
    func getNumberOfRowsInSearchTableView() -> Int {
        return filteredMenuItems.count
    }
    
    func getMenuItem(row: Int) -> OperationItem {
        return filteredMenuItems[row]
    }
    
    func updateFilteredMenuItems(searchText: String) {
        if searchText.isEmpty {
            filteredMenuItems = []
            return
        }
        
        let allMenuItems = SessionManager.shared.menu?.getAllMenuItems() ?? []
        filteredMenuItems = allMenuItems.filter({$0.name?.lowercased().contains(searchText.lowercased()) ?? false })
    }
    
    func getProfilePhoto() -> Single<Data?> {
        return Single.create { [weak self] single in
            guard let self = self,
                  let username = SessionManager.shared.profile?.additionalProfileInfo?.username else { return Disposables.create { } }
            
            self.profileService.getProfilePhoto(username: username)
                .subscribe { data in
                    single(.success(data))
                } onFailure: { error in
                    single(.failure(ApiError.internalServerError))
                }.disposed(by: self.disposeBag)
            
            return Disposables.create { }
        }
    }
}
