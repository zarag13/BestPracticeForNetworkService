//
//  JSONCodable.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 17.08.2023.
//

import Foundation


//MARK: - JSONCodableProtocol
protocol JSONCodableProtocol {
    func decodeJson<T: Codable>(type: T.Type, from: Data) -> T?
}

class JSONCodable: JSONCodableProtocol {

    func decodeJson<T: Codable>(type: T.Type, from: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type.self, from: from)
            return object
        }catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
