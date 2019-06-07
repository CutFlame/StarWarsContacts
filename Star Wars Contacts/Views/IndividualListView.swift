//
//  IndividualListView.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

struct IndividualListView: View {

    @EnvironmentObject var viewModel: IndividualListViewModel
    var body: some View {
        NavigationView {
            List(viewModel.items) { item in
                NavigationButton(destination: IndividualDetailView().environmentObject(item), isDetail: true) {
                    IndividualRow().environmentObject(item)
                }
            }
            .navigationBarTitle(Text("Individuals"))
        }
    }

}

#if DEBUG
struct IndividualListView_Previews : PreviewProvider {
    static var models = PreviewDatabase.individuals.map(IndividualDetailViewModel.init)
    static var viewModel = IndividualListViewModel(items: models)
    static var previews: some View {
        IndividualListView()
        .environmentObject(viewModel)
    }
}
#endif
