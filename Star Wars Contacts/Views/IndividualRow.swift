//
//  IndividualRow.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import SwiftUI

struct IndividualRow: View {
    @State var image: CGImage? = nil
    @State var name: String = ""

    var body: some View {
        HStack() {
            Image(decorative: image ?? Theme.defaultImage, scale: 20)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 10)

            Text(name)
        }
    }
}

#if DEBUG
struct IndividualRow_Previews : PreviewProvider {
    static var model = PreviewDatabase.individuals[0]
    static var previews: some View {
        Group {
            IndividualRow(image: nil, name: "No Name")
                .previewLayout(.fixed(width: 300, height: 70))
            IndividualRow(image: #imageLiteral(resourceName: "07").cgImage, name: "Luke S")
                .previewLayout(.fixed(width: 300, height: 70))
        }
    }
}
#endif
