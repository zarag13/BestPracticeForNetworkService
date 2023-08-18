//
//  NetworkService.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 17.08.2023.
//

import Foundation
import UIKit


//MARK: - PhotosNetworkServiceProtocol
protocol NetworkServiceProtocol {
    var task: CreateDataTaskProtocol { get set }
    var staticRequest: CreateRequestProtocol { get set }
    func requestTask(searchTerm: String?, complition: @escaping (Result<Data, Error>) -> Void)
    init(task: CreateDataTaskProtocol, staticRequest: CreateRequestProtocol)
}


class StaticNetworkService2: NetworkServiceProtocol {
    
    var task: CreateDataTaskProtocol
    var staticRequest: CreateRequestProtocol
    
    func requestTask(searchTerm: String?, complition: @escaping (Result<Data, Error>) -> Void) {
        
        let request = staticRequest.createRequest(searchTerm: searchTerm)
        
        let task = self.task.createDataTask(from: request) { data, error in
            guard let data = data else {
                complition(.failure(error!))
                return
            }
            complition(.success(data))
        }
        task.resume()
    }
    
    required init(task: CreateDataTaskProtocol, staticRequest: CreateRequestProtocol) {
        self.task = task
        self.staticRequest = staticRequest
    }
}













