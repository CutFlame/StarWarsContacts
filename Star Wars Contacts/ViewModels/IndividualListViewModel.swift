//
//  IndividualListViewModel.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI
import Combine

class IndividualListViewModel: BindableObject {
    let didChange = PassthroughSubject<IndividualListViewModel, Never>()
    let didSelectedIndividual = PassthroughSubject<IndividualDetailViewModel, Never>()

    let directoryService: DirectoryServiceProtocol

    private(set) var items = [IndividualDetailViewModel]() {
        didSet {
            didChange.send(self)
        }
    }

    private(set) var error: Error? = nil {
        didSet {
            didChange.send(self)
        }
    }

    init(items: [IndividualDetailViewModel] = []) {
        self.items = items
        self.directoryService = Injector.directoryService
    }

    func fetchItems() {
        directoryService.fetchDirectory(handleDirectoryResult)
    }
    func selectItem(item: IndividualDetailViewModel) {
        didSelectedIndividual.send(item)
    }

    func handleDirectoryResult(result: DirectoryResult) {
        switch result {
        case .success(let items):
            self.items = items.map(IndividualDetailViewModel.init)
        case .failure(let error):
            print("ERROR: \(error)")
        }
    }


}
