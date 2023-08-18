//
//  CreateDataTask.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 17.08.2023.
//

import Foundation

protocol CreateDataTaskProtocol {
    func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask
}

class CreateDataTask: CreateDataTaskProtocol {
    func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        
        //политику кеширования наследуют все URLRequest
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(memoryCapacity: 50000000, diskCapacity: 50000000, diskPath: "images")
        config.httpMaximumConnectionsPerHost = 5
        
        let session = URLSession(configuration: config)
        
        
        return session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                complition(data, error)
            }
        }
    }
}

