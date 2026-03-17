//
//  ConnectionManager_Auth.swift
//  MovilidadUK
//
//  Created by Diego Quimbo on 4/1/22.
//

import Alamofire
import RxSwift
import XMLMapper

class ConnectionManager_Auth: ConnectionManager {

    func login(user: String, password: String) -> Single<ServiceError?> {
        return Single.create { [weak self] single in
//            // Mock login - no VPN needed
//            let loginError = XMLMapper<ServiceError>().map(XMLfile: "mock_login.xml")
//            single(.success(loginError))
//            return Disposables.create { }

            let parameters = [
                "Domain": ConnectionManager.domain,
                "User": user,
                "password": password
            ]

            let request = self?.session.request(URLs.Auth.login(), method: .post, parameters: parameters, encoding: URLEncoding.queryString, headers: ConnectionManager.headers)
                .responseString(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        let loginError = ServiceError(XMLString: data)
                        single(.success(loginError))
                    case .failure(let error):
                        single(.failure(error))
                    }
                })

            return Disposables.create {
                request?.cancel()
            }
        }
    }
}
