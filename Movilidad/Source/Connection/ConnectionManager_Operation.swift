//
//  ConnectionManager_Operation.swift
//  Movilidad
//
//  Created by Diego Quimbo on 25/2/22.
//

import Alamofire
import RxSwift
import XMLMapper

class ConnectionManager_Operation: ConnectionManager {
    
    func operation(guid: String) -> Single<String> {
        return Single.create { [weak self] single in
//            let pageForm = XMLMapper<OperationForm>().map(XMLfile: "basic_test.xml")
//            single(.success(""))
//            return Disposables.create { }
            
            let request = self?.session.request(URLs.Operation.operation(guid: guid), method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: ConnectionManager.headers)
                .responseString(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(data))
                    case .failure(_):
                        single(.failure(ApiError.internalServerError))
                    }
                })

            return Disposables.create {
                request?.cancel()
            }
        }
    }
    
    func operationTrigger(guid: String, form: OperationForm, triggerId: String) -> Single<String> {
        return Single.create { [weak self] single in
                        
            let parameters = [
                "__EVENTARGUMENT": "TargetEntityTrigger",
                "__EVENTTARGET": triggerId,
                "__tmp_inputContextInfo": form.context?.mergeContextInfo ?? "",
                "__tmp_context__contextId": form.context?.id ?? 0,
                "__tmp_context__chunk0": form.context?.innerContext ?? "",
                "__COMPRESSED_VIEWSTATE__chunk0": form.viewState,
                "__COMPRESSED_VIEWSTATE__chunkCount": 1,
                "__tmp_context__chunkCount": 1,
                "__VIE WSTATE": ""
            ] as [String : Any]
            
            let request = self?.session.request(URLs.Operation.operation(guid: guid), method: .post, parameters: parameters, encoding: URLEncoding.default, headers: ConnectionManager.headers)
                .responseString(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(data))
                    case .failure(_):
                        single(.failure(ApiError.internalServerError))
                    }
                })

            return Disposables.create {
                request?.cancel()
            }
        }
    }
    
    func getTiles(guid: String) -> Single<TileControls?> {
        return Single.create { [weak self] single in
            let request = self?.session.request(URLs.Operation.getTiles(guid: guid), method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: ConnectionManager.headers)
                .responseString(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        let tilesControl =  TileControls(XMLString: data)
                        
                        single(.success(tilesControl))
                    case .failure(_):
                        single(.failure(ApiError.internalServerError))
                    }
                })

            return Disposables.create {
                request?.cancel()
            }
        }
    }
}
