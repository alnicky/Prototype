//
//  Market.swift
//  Prototype
//
//  Created by Никита on 18.04.2022.
//

import Foundation

struct DataFromMarket: Codable {
    let marketdata: MarketData
}

struct MarketData: Codable {
    let data: [[BoardMarketData]]
    let columns: [String]
}

enum BoardMarketData: Codable {
    
    case string(String)
    case integer(Int)
    case double(Double)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
//        if let x = try? container.decode(Int.self) {
//            self = .integer(x)
//            return
//        }
        
        if let x = try? container.decode(Double.self) {
            self = .double(x)
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
        
        throw DecodingError.typeMismatch(BoardMarketData.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for market"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
    
}


extension BoardMarketData {
    
    // MARK: Getting raw values
    
    func getStringValue() -> String? {
        switch self {
        case .string(let value):
            return value
        default:
            return "Нет информации"
        }
    }
    
//    func getIntValue() -> Int? {
//        switch self {
//        case .integer(let value):
//            return value
//        default:
//            return nil
//        }
//    }
    
    func getDoubleValue() -> Double? {
        switch self {
        case .double(let value):
            return value
        default:
            return nil
        }
    }
    
}

//extension MarketData {
//
//    // MARK: Getting number of item in columns
//
//    func getColumnNameNumber(name: String) -> Int {
//        self.columns.firstIndex(of: name)!
//    }
//
//}
