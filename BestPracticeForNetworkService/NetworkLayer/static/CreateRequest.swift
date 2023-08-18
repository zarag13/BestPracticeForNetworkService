//
//  CreateRequest.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 17.08.2023.
//

import Foundation

protocol CreateRequestProtocol {
    func createRequest(searchTerm: String?) -> URLRequest
}


class CreateRequest: CreateRequestProtocol{
    
    var api: APIProtocol
    var url: URL?
    
    init(api: APIProtocol) {
        self.api = api
    }
    
    func createRequest(searchTerm: String?) -> URLRequest{
        
        if let searchTerm = searchTerm {
            let paramentrs = self.api.prepareParametr(searchTerm: searchTerm)
            url = self.api.crateURL(params: paramentrs!)
        } else {
            url = self.api.crateURL(params: nil)
        }
        
        var request = URLRequest(url: url!)
        
        request.timeoutInterval = api.timeoutInterval ?? 60
        
        if let headers = api.prepareHeaders() {
            //используется для авторизации
            request.allHTTPHeaderFields = headers
            //или request.addValue("application/json", forHTTPHeaderField: "Content-Type") - один конкретный ключ
        }
        //данные которые хотим отправить
        if let hhtpBody = api.prepareHhtpBody() {
            request.httpBody = hhtpBody
        }
        
        //какой тип задачи - принять/отправить и т.д
        request.httpMethod = api.httpMethpds.rawValue
        
        return request
    }
}
