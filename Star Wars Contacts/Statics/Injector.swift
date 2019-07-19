//
//  Injector.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation
import Swinject
import Alamofire

typealias DependencyResolver = Swinject.Resolver
typealias DependencyContainer = Container

extension DependencyContainer {
    static let resolver: DependencyResolver = Container() { container in
        container.register(RequestInterceptor.self, factory: { r in NetworkLogger() })
        container.register(Session.self, factory: { r in Session(configuration: URLSessionConfiguration.default, interceptor: r.resolve()) })
        container.register(ImageStoreProtocol.self, factory: { r in ImageStore() })
        container.register(DirectoryServiceProtocol.self, factory: { r in DirectoryService(resolver: r) })
    }
    static func resolve<T>() -> T {
        return resolver.resolve()
    }
    static func resolve<T>(_: T.Type) -> T {
        return resolver.resolve()
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
