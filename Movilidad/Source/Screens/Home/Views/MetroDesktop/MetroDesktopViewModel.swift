//
//  MetroDesktopViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 10/10/23.
//

import RxSwift
import Foundation

enum TileNavigation {
    case web(OperationWeb)
    case external(URL)
}

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
    func navigation(forTileAt index: Int) -> TileNavigation? {
        let tile = tiles[index]

        guard let navigationURL = tile.navigationString, !navigationURL.isEmpty else { return nil }

        guard SessionManager.shared.isTileActiveInProfile(activityId: tile.activityId ?? "") else {
            return nil
        }

        if navigationURL.hasPrefix("http") {
            // 1 - Absolute URL: open it in the web view as-is
            return .web(OperationWeb(externalURL: navigationURL))
        } else if navigationURL.hasPrefix("/") {
            // 2 - Server-relative URL: inject the server and open it in the web view
            return .web(OperationWeb(externalURL: "\(URLs.baseURL())\(navigationURL)"))
        } else {
            // 3 - Custom scheme (e.g. "microsoft-edge-https://"): open it externally
            guard let externalURL = URL(string: navigationURL) else { return nil }
            return .external(externalURL)
        }
    }

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
