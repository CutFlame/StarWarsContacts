//
//  IndividualDetailViewModel.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

typealias IndividualDetailViewModel = IndividualModel

extension IndividualDetailViewModel: Identifiable {
    var fullName: String {
        var names = [String]()
        if !self.firstName.isEmpty {
            names.append(firstName)
        }
        if !self.lastName.isEmpty {
            names.append(lastName)
        }
        return names.joined(separator: " ")
    }
    var image: Image {
        Image(uiImage: #imageLiteral(resourceName: "user"))
    }
}
