//
//  NetworkDataFetcher.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 17.08.2023.
//

import Foundation

protocol NetworkDataFetcherProtocol {
    func getImage(serachTerm: String?, complition: @escaping (Codable?) -> Void )
    func postJSON(complition: @escaping (Any?) -> Void )
    func getImage2(complition: @escaping (Data?) -> Void )
}

class NetworkDataFetcher: NetworkDataFetcherProtocol {
    
    var network: NetworkServiceProtocol
    var jsoncodable: JSONCodableProtocol?
    var model: Codable.Type

    
    init(network: NetworkServiceProtocol, jsoncodable: JSONCodableProtocol?, model: Codable.Type) {
        self.network = network
        self.jsoncodable = jsoncodable
        self.model = model
    }
    
    
    //получаем картинку
    func getImage(serachTerm: String?, complition: @escaping (Codable?) -> Void ) {
        network.requestTask(searchTerm: serachTerm) { results in
            switch results {
            case .success(let data):
                print(data)
                let decode = self.jsoncodable?.decodeJson(type: self.model, from: data)
                complition(decode)
            case .failure(let error):
                print(error.localizedDescription)
                complition(nil)
            }
        }
    }
    
    func postJSON(complition: @escaping (Any?) -> Void ) {
        network.requestTask(searchTerm: nil) { results in
            switch results {
            case .success(let data):
                print(data)
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data)
                    print(json)
                    complition(json)
                }catch {
                    print(error.localizedDescription)
                    complition(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                complition(nil)
            }
        }
    }
    
    func getImage2(complition: @escaping (Data?) -> Void ) {
        network.requestTask(searchTerm: nil) { results in
            switch results {
            case .success(let data):
                //print(data)
                complition(data)
                
            case .failure(let error):
                print(error.localizedDescription)
                complition(nil)
            }
        }
    }
}
