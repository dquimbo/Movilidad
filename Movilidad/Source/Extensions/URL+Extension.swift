//
//  URL+Extension.swift
//  Movilidad
//
//  Created by Diego Quimbo on 26/4/23.
//

import Foundation

extension URL {
    var removingQueries: URL {
        if var components = URLComponents(string: absoluteString) {
            components.query = nil
            return components.url ?? self
        } else {
            return self
        }
    }
    
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}
