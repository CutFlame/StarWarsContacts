//
//  IndividualDetailView.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

struct IndividualDetailView: View {
    @EnvironmentObject var viewModel: IndividualDetailViewModel

    var birthDate: String {
        DateFormatters.displayDate.string(from: self.viewModel.birthdate)
    }
    var isForceSensitive: String {
        self.viewModel.isForceSensitive ? "YES" : "NO"
    }
    var affiliation: String {
        self.viewModel.affiliation.rawValue
    }

    private func getImage(for name:String) -> CGImage {
        let imageStore = DependencyContainer.resolve(ImageStoreProtocol.self)
        return imageStore.getImage(for: name) ?? Theme.defaultImage
    }

    var body: some View {
        NavigationView {
            VStack {
                Image(decorative: getImage(for: viewModel.imageURLPath), scale: 1)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)

                VStack(alignment: .leading) {
                    Text(viewModel.fullName)
                        .font(.title)
                        .padding(10)

                    LabelDetailRow(title: "Birthdate", value: birthDate)
                    LabelDetailRow(title: "Force Sensitive", value: isForceSensitive)
                    LabelDetailRow(title: "Affiliation", value: affiliation)
                }
                Spacer()
            }
                .padding()
                .navigationBarItems(leading: Button(action: viewModel.backAction) {
                    Text("Back")
                })
        }
    }

}

#if DEBUG
struct IndividualDetailView_Previews : PreviewProvider {
    static var model = PreviewDatabase.individuals[0]
    static var viewModel = IndividualDetailViewModel(model: model)
    static var previews: some View {
        return IndividualDetailView()
            .environmentObject(viewModel)
    }
}
#endif
