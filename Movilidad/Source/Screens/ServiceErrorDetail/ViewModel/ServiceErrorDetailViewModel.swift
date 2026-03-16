//
//  LoginErrorDetailViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 24/1/22.
//

final class ServiceErrorDetailViewModel {
    
    // Private Properties
    private var loginError: ServiceError?
    
    init(loginError: ServiceError?) {
        self.loginError = loginError
    }

    // MARK: - Public Vars
    var errorDescription: String {
        guard let error = loginError else {
            return ""
        }
        
        return "\(error.error.errorDescription ?? "") \n \(error.serverError ?? "") "
    }
    
}
