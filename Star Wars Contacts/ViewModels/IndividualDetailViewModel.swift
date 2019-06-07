//
//  IndividualDetailViewModel.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI
import Combine

//typealias IndividualDetailViewModel = IndividualModel

class IndividualDetailViewModel: BindableObject, Identifiable {
    let didChange = PassthroughSubject<IndividualDetailViewModel, Never>()

    static var defaultImage = UIImage(named: "user")!.cgImage!

    let imageStore: ImageStoreProtocol
    let directoryService: DirectoryServiceProtocol

    private let model: IndividualModel
    init(model:IndividualModel) {
        self.model = model
        self.imageStore = Injector.imageStore
        self.directoryService = Injector.directoryService
    }

    private(set) var error: Error? = nil {
        didSet {
            didChange.send(self)
        }
    }

    var id: Int { model.id }
    var birthdate: Date { model.birthdate }
    var isForceSensitive: Bool { model.isForceSensitive }
    var affiliation: AffiliationEnum { model.affiliation }
    var fullName: String { model.fullName }
    var image: CGImage {
        if let image = imageStore.getImage(for: model.profilePictureURL.path) {
            return image
        }
        fetchImage()
        return IndividualDetailViewModel.defaultImage
    }

    func fetchImage() {
        let key = model.profilePictureURL.path
        directoryService.fetchData(model.profilePictureURL) { [weak self] result in
            self?.handleImageDataResult(key, result)
        }
    }

    func handleImageDataResult(_ key:String, _ result:Result<Data, Error>) {
        switch result {
        case .success(let data):
            self.imageStore.addImage(for: key, data: data)
            self.didChange.send(self)
        case .failure(let error):
            self.error = error
        }
    }


}
