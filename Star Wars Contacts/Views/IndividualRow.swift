//
//  IndividualRow.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

struct IndividualRow: View {
    var viewModel: IndividualDetailViewModel
    var body: some View {
        HStack() {
//            Image(uiImage: #imageLiteral(resourceName: "user"))
            viewModel.image
                .shadow(radius: 10)
                .frame(width: 50, height: 50)
                .imageScale(.small)
                .clipped()
                .foregroundColor(.gray)
                .scaledToFit()
                .fixedSize()

            Text(viewModel.fullName)
        }
    }
}

#if DEBUG
struct IndividualRow_Previews : PreviewProvider {
    static var previews: some View {
        IndividualRow(viewModel: PreviewDatabase.individuals[0])
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
#endif
