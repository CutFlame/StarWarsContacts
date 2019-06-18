//
//  IndividualListViewModel.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation
import protocol SwiftUI.BindableObject
import Combine

class IndividualListViewModel: BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    let didSelectedIndividual = PassthroughSubject<IndividualModel, Never>()

    let directoryService: DirectoryServiceProtocol
    let imageStore: ImageStoreProtocol

    private(set) var items = [IndividualModel]() {
        didSet {
            didChange.send(())
        }
    }

    private(set) var error: Error? = nil {
        didSet {
            didChange.send(())
        }
    }

    init(items: [IndividualModel] = [], injector: Injector = Injector.shared) {
        self.items = items
        self.directoryService = injector.resolve()
        self.imageStore = injector.resolve()
    }

    func fetchItems() {
        directoryService.fetchDirectory(handleDirectoryResult)
    }
    func selectItem(item: IndividualModel) {
        didSelectedIndividual.send(item)
    }
    func fetchImage(item: IndividualModel) {
        let key = item.profilePictureURL.path
        if imageStore.hasImage(for: key) { return }
        directoryService.fetchData(item.profilePictureURL) { [weak self] result in
            self?.handleImageDataResult(key, result)
        }
    }

    func handleImageDataResult(_ key:String, _ result:Result<Data, Error>) {
        switch result {
        case .success(let data):
            self.imageStore.addImage(for: key, data: data)
            self.didChange.send(())
        case .failure(let error):
            self.error = error
        }
    }

    func handleDirectoryResult(result: DirectoryResult) {
        switch result {
        case .success(let items):
            self.items = items
        case .failure(let error):
            print("ERROR: \(error)")
        }
    }


}
