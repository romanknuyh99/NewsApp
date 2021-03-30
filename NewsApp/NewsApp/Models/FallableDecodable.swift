//
//  FallableDecodable.swift
//  NewsApp
//
//  Created by Roman Kniukh on 30.03.21.
//

struct FallableDecodable<Value: Codable>: Codable {
    let value: Value?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        value = try? container.decode(Value.self)
    }
}
