//
//  ApiResponse.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import Foundation

protocol Keyed: Codable {
    associatedtype Value: Codable
    static var key: String { get }
}

struct ApiResponse<T: Keyed>: Codable {
    let data: [T.Value]?

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    struct DynamicCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        let key = DynamicCodingKey(stringValue: T.key)!
        data = try container.decodeIfPresent([T.Value].self, forKey: key)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        let key = DynamicCodingKey(stringValue: T.key)!
        try container.encodeIfPresent(data, forKey: key)
    }
}
