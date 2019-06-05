//
//  Coordinator.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

protocol CoordinatorProtocol {
    var child: CoordinatorProtocol? { get }
    func start()
}

class Coordinator {
    var child: CoordinatorProtocol?
}
