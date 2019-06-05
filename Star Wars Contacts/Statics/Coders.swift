//
//  Coders.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/4/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation

enum Decoders {
    static var json: JSONDecoder = newJSONDecoder()

    static func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .custom(decodeDate)

    static func decodeDate(from decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)

        if let date = DateFormatters.simpleDate.date(from: dateStr) {
            return date
        }
        if let date = DateFormatters.timestampWithDecimalMiliseconds.date(from: dateStr) {
            return date
        }
        if let date = DateFormatters.timestampWithMiliseconds.date(from: dateStr) {
            return date
        }

        throw DecodingError.typeMismatch(Date.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode date"))
    }

}

enum Encoders {
    static var json: JSONEncoder = newJSONEncoder()

    static func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatters.simpleDate)
        return encoder
    }
}
