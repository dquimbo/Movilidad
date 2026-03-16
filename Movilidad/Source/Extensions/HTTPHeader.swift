//
//  HTTPHeader.swift
//  Movilidad
//
//  Created by Diego Quimbo on 21/1/22.
//

import Alamofire

extension HTTPHeader {
    public static func mdwclientCapabilities(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "mdwclient-capabilities", value: value)
    }
    
    public static func mdwclientDevice() -> HTTPHeader {
        HTTPHeader(name: "mdwclient-device", value: "iPhone")
    }
    
    public static func mdwclientVersion() -> HTTPHeader {
        HTTPHeader(name: "mdwclient-version", value: "4.23")
    }
    
    public static func ipadclient() -> HTTPHeader {
        HTTPHeader(name: "ipadclient", value: "7857")
    }
}
