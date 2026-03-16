//
//  ConnectionManager_Profile.swift
//  Movilidad
//
//  Created by Diego Quimbo on 26/1/22.
//

import Alamofire
import RxSwift
import XMLMapper
import Foundation

class ConnectionManager_Profile: ConnectionManager {
    
    func profile() -> Single<Profile?> {
        return Single.create { [weak self] single in
            
            let request = self?.session.request(URLs.Profile.profile(), method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: ConnectionManager.headers)
                .responseString(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        let profile =  Profile(XMLString: data)
                        
                        single(.success(profile))
                    case .failure(let error):
                        single(.failure(error))
                    }
                })
            
            return Disposables.create {
                request?.cancel()
            }
        }
    }
    
    func menu(profile: String) -> Single<Menu?> {
        return Single.create { [weak self] single in
            let request = self?.session.request(URLs.Profile.menu(profile: profile), method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: ConnectionManager.headers)
                .responseString(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        let menu =  Menu(XMLString: data)
                        
                        single(.success(menu))
                    case .failure(let error):
                        single(.failure(error))
                    }
                })
            
            return Disposables.create {
                request?.cancel()
            }
        }
    }
    
    func profileAdditionalInfo() -> Single<AdditionalProfileInfo?> {
        return Single.create { [weak self] single in
            let credentials = Keychain.shared.getUserCredentials()
            
            let parameters = [
                "username": credentials?.user ?? ""
            ]
            
            let request = self?.session.request(URLs.Profile.profileExtraInfo(), method: .post, parameters: parameters, encoding: URLEncoding.queryString, headers: ConnectionManager.headers)
                .responseString(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        let additionalInfo =  AdditionalProfileInfo(XMLString: data)
                        
                        single(.success(additionalInfo))
                    case .failure(let error):
                        single(.failure(error))
                    }
                })
            
            return Disposables.create {
                request?.cancel()
            }
        }
    }
    
    func notificationsCount() -> Single<Int> {
        return Single.create { [weak self] single in
            let request = self?.session.request(URLs.Profile.notificationsCount(), method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: ConnectionManager.headers)
                .responseString(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        var notificationsCount = 0
                        if let notificationsCountValue = Int(data) {
                            notificationsCount = notificationsCountValue
                        }
                        
                        single(.success(notificationsCount))
                    case .failure(_):
                        single(.failure(ApiError.internalServerError))
                    }
                })
            
            return Disposables.create {
                request?.cancel()
            }
        }
    }
    
    func registerPushNotificationToken(token: String) -> Single<Bool> {
        return Single.create { [weak self] single in
            let tokenPush = [
                "ID": SettingsHandler.shared.deviceName,
                "Token": token,
                "DeviceType": "IOS",
                "Environment": "1"
            ]
            
            let credentials = Keychain.shared.getUserCredentials()
            
            let parameters = [
                "AppName": SettingsHandler.shared.appName,
                "UserName": credentials?.user ?? "",
                "PendingNotifications": "0",
                "TokenDevice": tokenPush
            ] as [String : Any]
            
            
            
            let request = self?.session.request(URLs.Profile.registerPushNotifications, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ConnectionManager.headersPushNotifications).response(completionHandler: { response in
                switch response.result {
                case .success(_ ):
                    let statusCode = response.response?.statusCode ?? 0
                    single(.success(statusCode == 200))
                case .failure(_ ):
                    single(.failure(ApiError.internalServerError))
                }
            })
                        
            return Disposables.create {
                request?.cancel()
            }
        }
    }
    
    func getProfilePhoto(username: String) -> Single<Data?> {
        return Single.create { [weak self] single in
            let request = self?.session.request(URLs.Profile.profilePhoto(username: username), method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: ConnectionManager.headers)
                .response(completionHandler: { response in
                    
                    single(.success(response.data))
                })
            return Disposables.create {
                request?.cancel()
            }
        }
    }
}
