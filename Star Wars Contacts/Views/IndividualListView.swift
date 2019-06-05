//
//  IndividualListView.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

struct IndividualRow: View {
    var viewModel: IndividualDetailViewModel
    var body: some View {
        HStack {
            viewModel.image
                .shadow(radius: 10)
                .frame(width: 50, height: 50)
                .scaledToFill()
                .clipped()

            Text(viewModel.fullName)
        }
    }
}


struct IndividualListView: View {

    var viewModel: IndividualListViewModel
    var body: some View {
        NavigationView {
            List(viewModel.items) { item in
                NavigationButton(destination: IndividualDetailView(viewModel: item), isDetail: true) {
                    IndividualRow(viewModel: item)
                }
                }
                .navigationBarTitle(Text("Individuals"))
        }
    }

}

//#if DEBUG
//struct IndividualListView_Previews : PreviewProvider {
//    static var previews: some View {
//        IndividualListView()
//    }
//}
//#endif
