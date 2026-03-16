//
//  LoginViewModel.swift
//  DemoMovilidad-UK
//
//  Created by Diego Quimbo on 4/1/22.
//

import RxSwift
import RxCocoa

final class LoginViewModel {
    
    // Public Properties
    // Needs to show or hide a loading, just send an event
    let hideLoading = BehaviorRelay<Bool>(value: true)
    // Save login error reference to show the detail error screen in case the user wants to watch a detailed error
    var loginError: ServiceError?
    
    // Private Properties
    private let authService = ConnectionManager_Auth()
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // MARK: - Public Functions
    func signIn(user: String, password: String) -> Single<ServiceError?> {
        authService.refreshTrustServer()
        
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create { } }
            
            // Notify subscriber to show the indicator view
            self.hideLoading.accept(false)
            
            self.authService.login(user: user, password: password)
                .subscribe { [weak self] loginError in
                    // Notify subscribers to hide the indicator view
                    self?.hideLoading.accept(true)
                    
                    self?.loginError = loginError
                    single(.success(loginError))
                } onFailure: { error in
                    // Notify subscribers to hide the indicator view
                    self.hideLoading.accept(true)
                    
                    self.loginError = ServiceError(afError: error)
                    
                    single(.failure(ApiError.internalServerError))
                }.disposed(by: self.disposeBag)
            
            return Disposables.create { }
        }
    }
    
    func saveCredentials(user: String, password: String) {
        Keychain.shared.saveUserCredentials(email: user, password: password)
    }
    
    func serverSelectedHasChanged() {
        // If the server selected has changed, change the connection session in order to trust in the new server address
        authService.refreshTrustServer()
    }
}
