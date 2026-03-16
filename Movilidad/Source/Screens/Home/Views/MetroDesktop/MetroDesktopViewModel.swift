//
//  MetroDesktopViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 10/10/23.
//

import RxSwift

final class MetroDesktopViewModel {
    
    // Private Properties
    private let operationService = ConnectionManager_Operation()
    private let guid: String
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // Public vars
    public var tiles: [Tile] = []
    
    init(guid: String) {
        self.guid = guid
    }
    
    // Public Functions
    func getTiles() -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create { } }
            
            self.operationService.getTiles(guid: guid)
                .subscribe { tileControls in
                    guard let tileValues = tileControls?.tiles, !tileValues.isEmpty else {
                        single(.failure(ApiError.internalServerError))
                        return
                    }
                    
                    self.tiles = tileValues
                    
                    single(.success(()))
                } onFailure: { error in
                    single(.failure(ApiError.internalServerError))
                }.disposed(by: self.disposeBag)
            
            return Disposables.create { }
        }
    }
}
