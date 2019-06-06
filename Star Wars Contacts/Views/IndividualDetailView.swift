//
//  IndividualDetailView.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

struct LabelRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack() {
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.subheadline)
        }
    }
}

struct IndividualDetailView: View {
    var viewModel: IndividualDetailViewModel

    var birthDate: String {
        DateFormatters.displayDate.string(from: self.viewModel.birthdate)
    }
    var isForceSensitive: String {
        self.viewModel.isForceSensitive ? "YES" : "NO"
    }
    var affiliation: String {
        self.viewModel.affiliation.rawValue
    }

    var body: some View {
        VStack {
            Image(decorative: viewModel.image, scale: 1)
                .resizable()
//                .aspectRatio(contentMode: ContentMode.fit)
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200, alignment: .center)
//            .clipped()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)

            VStack(alignment: .leading) {
                Text(viewModel.fullName)
                    .font(.title)
                    .padding(10)

                LabelRow(title: "Birthdate", value: birthDate)
                LabelRow(title: "Force Sensitive", value: isForceSensitive)
                LabelRow(title: "Affiliation", value: affiliation)
            }

            Spacer()
        }
        .padding()
    }

}

#if DEBUG
struct IndividualDetailView_Previews : PreviewProvider {
    static var model = PreviewDatabase.individuals[0]
    static var viewModel = IndividualDetailViewModel(model: model)
    static var previews: some View {
        return IndividualDetailView(viewModel: viewModel)
    }
}
#endif
