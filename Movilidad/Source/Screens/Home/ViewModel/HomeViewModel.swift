//
//  HomeViewModel.swift
//  MovilidadUK
//
//  Created by Diego Quimbo on 4/1/22.
//

import RxSwift
import RxCocoa
import Foundation

final class HomeViewModel {
    
    // Private Properties
    private let profileService = ConnectionManager_Profile()
    private let operationService = ConnectionManager_Operation()
    private var isFirstLoad = true
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // MARK: - Public Vars
    var hasLicence: Bool {
        guard let profileValue = SessionManager.shared.profile else {
            return false
        }
        
        return profileValue.licenceServer == "OK"
    }
    
    var username: String {
        return SessionManager.shared.profile?.additionalProfileInfo?.displayName ?? ""
    }
    
    var titleProfile: String {
        return SessionManager.shared.profile?.additionalProfileInfo?.title ?? ""
    }
    
    var profileDescription: String {
        return SessionManager.shared.profile?.profileSelected?.descripcion ?? ""
    }
    
    var serviceError: ServiceError?
    
    // MARK: - Public Functions
    func getProfile() -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create { } }
            
            self.profileService.profile()
                .subscribe { profile in
                    guard let profileValue = profile else {
                        single(.failure(ApiError.internalServerError))
                        return
                    }
                    
                    SessionManager.shared.profile = profileValue
                    
                    single(.success(true))
                } onFailure: { error in
                    self.serviceError = ServiceError(afError: error)
                    single(.failure(ApiError.internalServerError))
                }.disposed(by: self.disposeBag)
            
            return Disposables.create { }
        }
    } 
    
    func getMenu() -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self,
                  var profileGuid = SessionManager.shared.profile?.profileSelectedGuid  else { return Disposables.create { } }
            
            if self.isFirstLoad {
                self.isFirstLoad.toggle()
                
                // Check if exist inital profile saved in settings.plist file
                if let initalProfile = SettingsHandler.shared.getInitialProfile() {
                    // Change the initial profile setted from server to the initial profile saved in the app settings
                    SessionManager.shared.changeProfileSelected(profileItemID: initalProfile.id ?? "")
                    profileGuid = initalProfile.id ?? ""
                }
            }
            
            self.profileService.menu(profile: profileGuid)
                .subscribe { menu in
                    guard let menuValue = menu else {
                        let localizedError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: L10n.Service.Menu.error])
                        self.serviceError = ServiceError(afError: localizedError)
                        
                        single(.failure(ApiError.internalServerError))
                        return
                    }
                    
                    SessionManager.shared.menu = menuValue
                    
                    
                    single(.success(true))
                } onFailure: { error in
                    self.serviceError = ServiceError(afError: error)
                    
                    single(.failure(ApiError.internalServerError))   
                }.disposed(by: self.disposeBag)
            
            return Disposables.create { }
        }
    }
    
    func getAdditionalProfileInfo() -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create { } }
            
            self.profileService.profileAdditionalInfo()
                .subscribe { info in
                    guard let infoValue = info else {
                        let localizedError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: L10n.Service.ProfileExtraInfo.error])
                        self.serviceError = ServiceError(afError: localizedError)
                        
                        single(.failure(ApiError.internalServerError))
                        return
                    }
                    
                    SessionManager.shared.profile?.additionalProfileInfo = info
                    
                    single(.success(true))
                } onFailure: { error in
                    self.serviceError = ServiceError(afError: error)
                    
                    single(.failure(ApiError.internalServerError))
                }.disposed(by: self.disposeBag)
            
            return Disposables.create { }
        }
    }
    
    func getNotificationsCount() -> Single<Int> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create { } }
            
            self.profileService.notificationsCount()
                .subscribe { value in
                    single(.success(value))
                } onFailure: { error in
                    self.serviceError = ServiceError(afError: error)
                    
                    single(.failure(ApiError.internalServerError))
                }.disposed(by: self.disposeBag)
            
            return Disposables.create { }
        }
    }
    
    func registerPushNotifications() {
        guard let pushToken = SettingsHandler.shared.pushNotificationsToken else { return }
        
        self.profileService.registerPushNotificationToken(token: pushToken)
            .subscribe { value in
                let result = value ? "Push notification token has been registered" : "There was an error registering push notification token"
                print(result)
            } onFailure: { error in
                print("There was an error registering push notification token")
            }.disposed(by: self.disposeBag)
    }
    
    func buildOperationForWorkflow(operation: OperationItem) -> OperationWeb {
        return OperationWeb(workflowId: operation.id ?? "")
    }
    
    func buildExternalOperationNotifications() -> OperationWeb {
        return OperationWeb(externalURL: URLs.Operation.notificationsWebView())
    }
    
    func buildExternalOperationTriggedFromWebView(url: String) -> OperationWeb {
        return OperationWeb(externalURL: url)
    }
}
