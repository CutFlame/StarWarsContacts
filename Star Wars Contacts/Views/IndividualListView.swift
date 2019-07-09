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
            List(viewModel.items.identified(by: \.id)) { item in
                Button(action: {
                    self.viewModel.selectItem(item: item)
                }, label: {
                    IndividualRow(image: self.getImage(for: item), name: item.fullName)
                    })
                    .onAppear(perform: {
                            self.viewModel.fetchImage(item: item)
                        })
            }
            .navigationBarTitle(Text("Individuals"))
        }
    }

    func getImage(for item: IndividualModel) -> CGImage? {
        nil
        //viewModel.
    }

    func convertToImage(_ data:Data) -> CGImage? {
        guard
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            else {
                return nil
        }
        return image
    }
}

#if DEBUG
struct IndividualListView_Previews : PreviewProvider {
    static var models = PreviewDatabase.individuals
    static var viewModel = IndividualListViewModel(items: models)
    static var previews: some View {
        IndividualListView()
            .environmentObject(viewModel)
    }
}
#endif
