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
    
    static var defaultImage = UIImage(named: "user")!.cgImage!

    var image: CGImage {
        guard
            let url = Bundle.main.url(forResource: profilePictureURL.path, withExtension: nil),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            else {
                print("Couldn't load image \(profilePictureURL.path) from main bundle.")
                return IndividualDetailViewModel.defaultImage
        }
        return image
    }
}

#if DEBUG
struct IndividualDetailViewModel_Previews : PreviewProvider {
    static var model = PreviewDatabase.individuals[0]

    static var previews: some View {
        VStack {
            Image(decorative: model.image, scale: 10)
            Text(model.fullName)
        }
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
