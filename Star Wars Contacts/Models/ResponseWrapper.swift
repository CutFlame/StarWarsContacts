//
//  ResponseWrapper.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation

// MARK: - Wrapper
struct ResponseWrapper: Codable {
    let individuals: [IndividualModel]
}

extension ResponseWrapper {
    init(data: Data) throws {
        self = try Decoders.json.decode(ResponseWrapper.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}
