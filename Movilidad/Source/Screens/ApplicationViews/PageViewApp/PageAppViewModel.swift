//
//  PageViewAppViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 22/3/22.
//

import CoreGraphics
import RxSwift

final class PageAppViewModel {
    let operation: OperationItem
    var operationForm: OperationForm
    
    // Private Properties
    private let operationService = ConnectionManager_Operation()
    private let heightForContent = 120.0
    private let heightForControlItems = 35.0
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    init(operation: OperationItem, operationForm: OperationForm) {
        self.operation = operation
        self.operationForm = operationForm
    }
    
    // Public Functions
    func calculateHeightForFormContainer(formContainer: FormControlContainer) -> CGFloat {
        let heightTotalForControls = Double(formContainer.controls.count) * heightForControlItems
        return heightForContent + heightTotalForControls
    }
    
    func sendOperationTrigger(itemId: String) -> Single<String> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create { } }
            
            self.operationService.operationTrigger(guid: self.operation.id ?? "",
                                                   form: self.operationForm,
                                                   triggerId: itemId)
                .subscribe { operationData in
                    if let operation = OperationForm(XMLString: operationData) {
                        self.operationForm = operation
                    }
                    
                    single(.success(operationData))
                } onFailure: { error in
                    single(.failure(ApiError.internalServerError))
                }.disposed(by: self.disposeBag)
            
            return Disposables.create { }
        }
    }
}
