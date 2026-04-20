//
//  MetroSearchViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 20/4/26.
//

import Foundation

final class MetroSearchViewModel {

    // Private Properties
    private var filteredTiles: [OperationItem] = []

    // Public Properties
    var allTiles: [OperationItem] {
        return SessionManager.shared.getAllTileOperations() ?? []
    }

    // MARK: - Public Functions
    func getNumberOfRows() -> Int {
        return filteredTiles.count
    }

    func getTile(row: Int) -> OperationItem {
        return filteredTiles[row]
    }

    func updateFilteredTiles(searchText: String) {
        if searchText.isEmpty {
            filteredTiles = []
            return
        }

        filteredTiles = allTiles.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
    }
}
