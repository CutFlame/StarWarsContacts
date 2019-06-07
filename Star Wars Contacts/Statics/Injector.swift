//
//  Injector.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation

enum Injector {
    static let imageStore: ImageStoreProtocol = ImageStore()
    static let directoryService: DirectoryServiceProtocol = DirectoryService()
}
