//
//  DesktopAppViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 18/3/22.
//

import UIKit
import Foundation
import RxSwift

final class DesktopContentAppViewModel {
    let operation: OperationItem?
    let externalOperationWebView: OperationWeb?
    
    // Private Properties
    private let operationService = ConnectionManager_Operation()
    private var operationForm: OperationForm?
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    init(operation: OperationItem?, externalOperationWebView: OperationWeb?) {
        self.operation = operation
        self.externalOperationWebView = externalOperationWebView
    }
    
    var operationTitle: String {
        if let operationName = operation?.name {
            return operationName
        }
        
        return ""
    }
    
    var favoriteImageStatus: UIImage {
        return SessionManager.shared.operationIsInFavoriteList(operation: operation) ? Asset.operationStarGold.image : Asset.operationStar.image
    }
    
    var isExternalOperationWebView: Bool {
        return externalOperationWebView != nil
    }
    
    var debugWebViewURL: String {
        guard let contextID = operationForm?.context?.id,
              let executionNode = operationForm?.context?.executionNode else {
            return ""
        }
        return "http://\(SettingsHandler.shared.serverSelected)/OperationsXPRuntime/OperationTrace.aspx?tempId=\(contextID)&node=\(executionNode)"
    }
    
    var isShowingStatusOperationInfo = false

    // MARK: - Public Functions
    func pressedFavoriteButton() {
        guard let operationWrap = operation else { return }
        SessionManager.shared.handleFavoriteAction(operation: operationWrap)
    }
    
    func getOperationInfo() -> Single<String> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create { } }
            
            self.operationService.operation(guid: self.operation?.id ?? "")
                .subscribe { [weak self] operationData in
                    // Save operation form in order to get data for debug view
                    if let operationType = self?.getHandlerTypeByOperationData(data: operationData), operationType == .Page {
                        self?.operationForm = OperationForm(XMLString: operationData)
                    }
                    
                    single(.success(operationData))
                } onFailure: { error in
                    single(.failure(ApiError.internalServerError))
                }.disposed(by: self.disposeBag)
            
            return Disposables.create { }
        }
    }
    
    func getHandlerTypeByOperationData(data: String) -> OperationHandlerType? {
        if data.contains(OperationHandlerType.ExternalWeb.rawValue) {
            return .ExternalWeb
        }
        
        if data.contains(OperationHandlerType.Page.rawValue) {
            return .Page
        }
        
        return nil
    }
}
