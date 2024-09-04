//
//  NetworkResponseModel.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 11/08/24.
//


import Foundation

enum Status: Codable {
    case bool(Bool)
    case string(String)
    
    // Custom decoding to handle both types
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(Status.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Bool or String for status"))
        }
    }
    
    // Custom encoding to handle both types
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let boolValue):
            try container.encode(boolValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        }
    }
}


struct NetworkResponseModel: Codable {
    let data: [Item]?
    let status: Status?
    let message: String?

    // Custom initializer to use decodeIfPresent
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent([Item].self, forKey: .data)
        status = try container.decodeIfPresent(Status.self, forKey: .status)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}

struct Item: Codable {
    let id: String?
    let name: String?
    let price: String?
    let date: String?
    let image: String?

    // Custom initializer to use decodeIfPresent
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        price = try container.decodeIfPresent(String.self, forKey: .price)
        date = try container.decodeIfPresent(String.self, forKey: .date)
        if let imagePath = try container.decodeIfPresent(String.self, forKey: .image) {
            image = "\(NetworkManagerService.shared.domainName)/Images/\(imagePath)"
        } else {
            image = nil
        }
    }

    // Map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case price = "Price"
        case date = "Date"
        case image = "Image"
    }
}
