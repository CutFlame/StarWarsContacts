//
//  IndividualRow.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

struct IndividualRow: View {
    @EnvironmentObject var viewModel: IndividualDetailViewModel
    var body: some View {
        HStack() {
            Image(decorative: viewModel.image, scale: 20)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 10)

            Text(viewModel.fullName)
        }
    }
}

#if DEBUG
struct IndividualRow_Previews : PreviewProvider {
    static var model = PreviewDatabase.individuals[0]
    static var viewModel = IndividualDetailViewModel(model: model)
    static var previews: some View {
        IndividualRow()
            .environmentObject(viewModel)
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
#endif
