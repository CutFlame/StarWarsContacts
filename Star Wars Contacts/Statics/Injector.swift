//
//  Injector.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import protocol Swinject.Resolver
import class Swinject.Container
import class Alamofire.Session

typealias DependencyResolver = Swinject.Resolver
typealias Injector = Container

extension Injector {
    static let shared = Container() { container in
        container.register(Session.self, factory: { r in Session.default })
        container.register(ImageStoreProtocol.self, factory: { r in ImageStore() })
        container.register(DirectoryServiceProtocol.self, factory: { r in DirectoryService(resolver: r) })
    }
    static func resolve<T>() -> T {
        return shared.resolve()
    }
    static func resolve<T>(_: T.Type) -> T {
        return shared.resolve()
    }
}

extension DependencyResolver {
    func resolve<T>() -> T {
        guard let result = self.resolve(T.self) else {
            fatalError("Could not resolve type: \(T.self). Did you forget to register it?")
        }
        return result
    }


}
