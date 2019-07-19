//
//  IndividualDetailViewModel.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import protocol SwiftUI.BindableObject
import Foundation
import Combine
import CoreGraphics

class IndividualDetailViewModel: BindableObject {
    let willChange = PassthroughSubject<IndividualDetailViewModel, Never>()
    let didNavigateBack = PassthroughSubject<Void, Never>()

    let imageStore: ImageStoreProtocol
    let directoryService: DirectoryServiceProtocol

    private let model: IndividualModel
    init(model:IndividualModel, resolver: DependencyResolver = DependencyContainer.resolver) {
        self.model = model
        self.imageStore = resolver.resolve()
        self.directoryService = resolver.resolve()
    }

    private(set) var error: Error? = nil {
        didSet {
            willChange.send(self)
        }
    }

    var id: ID { model.id }
    var birthdate: Date { model.birthdate }
    var isForceSensitive: Bool { model.isForceSensitive }
    var affiliation: AffiliationEnum { model.affiliation }
    var fullName: String { model.fullName }
    var imageID: ImageID { model.profilePictureLookupKey }

    func backAction() {
        didNavigateBack.send(())
    }

    func fetchImage() {
        let key = model.profilePictureLookupKey
        if imageStore.hasImage(for: key) { return }
        directoryService.fetchData(model.profilePictureURL) { [weak self] result in
            self?.handleImageDataResult(key, result)
        }
    }

    func getImage() -> CGImage {
        return imageStore.getImage(for: imageID) ?? Theme.defaultImage
    }

    func handleImageDataResult(_ key:String, _ result:Result<Data, Error>) {
        switch result {
        case .success(let data):
            self.imageStore.addImage(for: key, data: data)
            self.willChange.send(self)
        case .failure(let error):
            self.error = error
        }
    }
}
