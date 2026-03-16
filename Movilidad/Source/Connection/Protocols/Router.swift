//
//  Router.swift
//  MovilidadUK
//
//  Created by Diego Quimbo on 4/1/22.
//

protocol Router {
    associatedtype Route
    associatedtype Controller
    func route(route: Route)
    var controller: Controller { get }
}
