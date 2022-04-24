//
//  Boards.swift
//  Prototype
//
//  Created by Никита on 03.04.2022.
//

import Foundation

// MARK: Data from Boards
struct DataFromBoards: Codable {
    let boards: Boards
}

// MARK: Boards
struct Boards: Codable {
    let data: [[BoardData]]
    let columns: [String]
}


// MARK: Tool
enum BoardData: Codable {
    case string(String)
    case integer(Int)
    case null
    
    func getStringValue() -> String? {
        switch self {
        case .string(let value):
            return value
        default:
            return "Нет информации"
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
        
        throw DecodingError.typeMismatch(BoardData.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for board"))
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
