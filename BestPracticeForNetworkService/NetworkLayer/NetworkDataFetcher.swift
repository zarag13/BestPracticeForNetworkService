//
//  NetworkDataFetcher.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 17.08.2023.
//

import Foundation

protocol NetworkDataFetcherProtocol {
    func getDataForSearch(serachTerm: String?, complition: @escaping (Codable?) -> Void )
    func postData(complition: @escaping (Any?) -> Void )
    func getImage(complition: @escaping (Data?) -> Void )
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
    
    
    //получаем картинку по запросу слова
    func getDataForSearch(serachTerm: String?, complition: @escaping (Codable?) -> Void ) {
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
    
    
    //отправка данных + получение ответа от сервера
    func postData(complition: @escaping (Any?) -> Void ) {
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
    
    
    //простая загрузка картинки по url
    func getImage(complition: @escaping (Data?) -> Void ) {
        network.requestTask(searchTerm: nil) { results in
            switch results {
            case .success(let data):
                complition(data)
                
            case .failure(let error):
                print(error.localizedDescription)
                complition(nil)
            }
        }
    }
}
