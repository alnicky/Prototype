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
        throw DecodingError.typeMismatch(Paper.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Paper"))
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


func loadData() {
    let stringURL = "https://iss.moex.com/iss/securities.json"
    guard let url = URL(string: stringURL) else { return }

    let task = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        guard error == nil else {
            print(error?.localizedDescription ?? "noDesciption")
            return
        }
        guard let data = data else { return }
        guard let dataFromSecurities = try?  JSONDecoder().decode(DataFromSecurities.self, from: data) else {
            print("Error: can't parse Securities")
            return
        }
        //dump(dataFromSecurities)
        print(dataFromSecurities.securities.data[1][2])
    }
    task.resume()
}

let tmp = loadData()
