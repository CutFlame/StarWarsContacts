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

//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(firstName, forKey: .firstName)
//        try container.encode(lastName, forKey: .lastName)
//        try container.encode(birthdate, forKey: .birthdate)
//        try container.encode(profilePictureURL, forKey: .profilePictureURL)
//        try container.encode(isForceSensitive, forKey: .isForceSensitive)
//        try container.encode(affiliation.rawValue, forKey: .affiliation)
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(Int.self, forKey: .id)
//        self.firstName = try container.decode(String.self, forKey: .firstName)
//        self.lastName = try container.decode(String.self, forKey: .lastName)
//        self.birthdate = try container.decode(Date.self, forKey: .birthdate)
//        self.profilePictureURL = try container.decode(URL.self, forKey: .profilePictureURL)
//        self.isForceSensitive = try container.decode(Bool.self, forKey: .isForceSensitive)
//        self.affiliation = try container.decode(AffiliationEnum.self, forKey: .affiliation)
//    }


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
