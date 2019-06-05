//
//  PreviewDatabase.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation

#if DEBUG
enum PreviewDatabase {
    static let individuals:[IndividualModel] = FileManager.load("individuals.json", as: ResponseWrapper.self).individuals
}
#endif
