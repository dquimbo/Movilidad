//
//  NetworkToolViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 4/5/23.
//

final class NetworkToolViewModel {
    
    private(set) var serverSelected: String?
    
    // MARK: - Public Functions
    func saveServedSelected(server: String) {
        serverSelected = server
    }
}
