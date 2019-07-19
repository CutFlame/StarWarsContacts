//
//  IndividualModel.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation

typealias ID = Int
typealias ImageID = String

struct IndividualModel: Codable {
    let id: ID
    let firstName: String
    let lastName: String
    let birthdate: Date
    let profilePictureURL: URL
    let isForceSensitive: Bool
    let affiliation: AffiliationEnum

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "firstName"
        case lastName = "lastName"
        case birthdate = "birthdate"
        case profilePictureURL = "profilePicture"
        case isForceSensitive = "forceSensitive"
        case affiliation = "affiliation"
    }
}

extension IndividualModel {
    var fullName: String {
        var names = [String]()
        if !firstName.isEmpty {
            names.append(firstName)
        }
        if !lastName.isEmpty {
            names.append(lastName)
        }
        return names.joined(separator: " ")
    }
    var profilePictureLookupKey: ImageID {
        return profilePictureURL.lastPathComponent
    }
}

extension IndividualModel {
    init(data: Data) throws {
        self = try Decoders.json.decode(IndividualModel.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}
