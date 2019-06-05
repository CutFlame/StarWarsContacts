//
//  IndividualListView.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

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

#if DEBUG
struct IndividualListView_Previews : PreviewProvider {
    static var previews: some View {
        IndividualListView(viewModel: IndividualListViewModel(items: PreviewDatabase.individuals))
    }
}
#endif
