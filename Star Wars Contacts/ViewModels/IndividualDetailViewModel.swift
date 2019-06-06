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

    let imageStore = Injector.imageStore
    let directoryService = Injector.directoryService

    private let model: IndividualModel
    init(model:IndividualModel) {
        self.model = model
    }

    var id: Int { model.id }
    var birthdate: Date { model.birthdate }
    var isForceSensitive: Bool { model.isForceSensitive }
    var affiliation: AffiliationEnum { model.affiliation }
    var fullName: String { model.fullName }
    var image: CGImage {
        if let image = imageStore.imageCache[model.profilePictureURL.path] {
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
        self.imageStore.handleImageDataResult(key, result)
        self.didChange.send(self)
    }

}
