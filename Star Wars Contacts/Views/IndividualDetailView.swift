//
//  IndividualDetailView.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

struct IndividualDetailView: View {
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter
    }()
    var viewModel: IndividualDetailViewModel
    var body: some View {
        VStack {
            viewModel.image
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)

            VStack(alignment: .leading) {

                Text(self.viewModel.fullName)
                    .font(.title)

                createLabelRow(title: "Birthdate", value: self.dateFormatter.string(from: self.viewModel.birthdate))
                createLabelRow(title: "Force Sensitive", value: self.viewModel.isForceSensitive ? "YES" : "NO")
                createLabelRow(title: "Affiliation", value: self.viewModel.affiliation.rawValue)
                }
                .padding()

            Spacer()
        }

    }

    func createLabelRow(title: String, value: String) -> some View {
        return HStack() {
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.subheadline)
        }
    }
}

#if DEBUG
struct IndividualDetailView_Previews : PreviewProvider {
    static var previews: some View {
        return IndividualDetailView(viewModel: PreviewDatabase.individuals[0])
    }
}
#endif
