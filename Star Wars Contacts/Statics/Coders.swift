//
//  Coders.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/4/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation

enum Decoders {
    static let json: JSONDecoder = newJSONDecoder()

    private static func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }
    static let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .custom(decodeDate)

    static func decodeDate(from decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
        guard let date = decodeDate(from: dateStr) else {
            throw DecodingError.typeMismatch(Date.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode date"))
        }
        return date
    }

    static func decodeDate(from dateStr:String) -> Date? {
        if let date = DateFormatters.simpleDate.date(from: dateStr) {
            return date
        }
        if let date = DateFormatters.timestampWithDecimalMiliseconds.date(from: dateStr) {
            return date
        }
        if let date = DateFormatters.timestampWithMiliseconds.date(from: dateStr) {
            return date
        }
        return nil
    }

}

enum Encoders {
    static let json: JSONEncoder = newJSONEncoder()

    private static func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatters.simpleDate)
        return encoder
    }
}
