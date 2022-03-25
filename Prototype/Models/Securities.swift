//
//  Model.swift
//  Prototype
//
//  Created by Никита on 22.02.2022.
//

import Foundation

// MARK: - DataFromSecurities
struct DataFromSecurities: Codable {
    let securities: Securities
}

// MARK: - Securities
struct Securities: Codable {
    let data: [[Paper]]
}

enum Paper: Codable {

    case integer(Int)
    case string(String)
    case null
    
    func getStringValue() -> String? {
        switch self {
        case .string(let value):
            return value
        default:
            return nil
        }
    }
    
    func getIntValue() -> Int? {
        switch self {
        case .integer(let value):
            return value
        default:
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        
        throw DecodingError.typeMismatch(Paper.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for security"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}
