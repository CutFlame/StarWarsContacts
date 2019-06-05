//
//  Statics.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/4/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation

extension FileManager {

    /// Load object from JSON file
    /// - Example usage: `let landmarkData: [Landmark] = load("landmarkData.json")`
    static func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = Decoders.json
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}


enum DateFormatters {
    static var simpleDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    static var timestampWithDecimalMiliseconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    static var timestampWithMiliseconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter
    }()
}

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
