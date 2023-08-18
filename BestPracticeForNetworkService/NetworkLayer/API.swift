//
//  API.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 17.08.2023.
//

import Foundation
import UIKit

enum HttpMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIProtocol {
    var httpMethpds: HttpMethods { get }
    var timeoutInterval : Double? { get }
    func prepareParametr(searchTerm: String?) -> [String : String]?
    func crateURL(params: [String: String]?) -> URL
    func prepareHeaders() -> [String: String]?
    func prepareHhtpBody() -> Data?
}


class CreatePhotosAPI: APIProtocol {
    var timeoutInterval: Double? = nil
    var httpMethpds: HttpMethods = .get
    
    func prepareHhtpBody() -> Data? {
        nil
    }
    
    //необходимо по описанию работы с API
    func prepareParametr(searchTerm: String?) -> [String : String]? {
        var parametrs = [String:String]()
        parametrs["query"] = searchTerm
        parametrs["page"] = String(1)
        parametrs["per_page"] = String(30)
        //например query - то что ищем - само название картинок
        //page - сколько картинок хотим (сколько страниц)
        //per_page - сколько картинок хотим
        return parametrs
    }
    
    //создание URL - по которому будет запрос
    func crateURL(params: [String: String]?) -> URL {
        //https://api.unsplash.com/search/photos?page=16query=office
        var components = URLComponents()
        components.scheme = "https"   //https - http
        components.host = "api.unsplash.com"    // api.unsplash.com - имя сайта
        components.path = "/search/photos"    // - все то, что идет до ? знака - до параметров
        if let param = params {
            components.queryItems = param.map {    //сами параметры - все то что идет после ? page=16query=office
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        return components.url!
    }
    
    //авторизация доступа к API
    func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID pXj02h_AcA1BKxDiK4YeOY7EY6M0TQXrmauUOd1NDro"
        return headers
    }
}


class CreatePostsGetAPI: APIProtocol {
    var timeoutInterval: Double? = nil
    var httpMethpds: HttpMethods = .get
    
    func prepareHhtpBody() -> Data? {
        nil
    }
    
    func prepareParametr(searchTerm: String?) -> [String : String]? {
        return nil
    }
    
    func crateURL(params: [String : String]?) -> URL {
        //let url = "https://jsonplaceholder.typicode.com/posts"
        var components = URLComponents()
        components.scheme = "https"   //https - http
        components.host = "jsonplaceholder.typicode.com"    // api.unsplash.com - имя сайта
        components.path = "/posts"    // - все то, что идет до ? знака - до параметров
        
        return components.url!
    }
    
    func prepareHeaders() -> [String : String]? {
        nil
    }
}

class CreatePostsPostAPI: APIProtocol {
    var timeoutInterval: Double? = nil
    var httpMethpds: HttpMethods = .post
    
    func prepareHhtpBody() -> Data? {
        let userData = ["Course": "Networking", "Lessons": "GET and POST Request"]
        //преобразуем данные словаря в JSON формат (Data) - https://developer.apple.com/documentation/foundation/JSONSerialization
        guard let hhtpBody = try? JSONSerialization.data(withJSONObject: userData) else  { return nil}
        return hhtpBody
    }
    
    func prepareParametr(searchTerm: String?) -> [String : String]? {
        return nil
    }
    
    func crateURL(params: [String : String]?) -> URL {
        //let url = "https://jsonplaceholder.typicode.com/posts"
        var components = URLComponents()
        components.scheme = "https"   //https - http
        components.host = "jsonplaceholder.typicode.com"    // api.unsplash.com - имя сайта
        components.path = "/posts"    // - все то, что идет до ? знака - до параметров
        
        return components.url!
    }
    
    func prepareHeaders() -> [String : String]? {
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        return headers
    }
}

class DownloadImageAndCache: APIProtocol {
    var timeoutInterval: Double? = 10
    var httpMethpds: HttpMethods = .get
    
    func prepareParametr(searchTerm: String?) -> [String : String]? {
        nil
    }
    
    func crateURL(params: [String : String]?) -> URL {
        //"https://fikiwiki.com/uploads/posts/2022-02/1644865252_26-fikiwiki-com-p-skachat-kartinki-khoroshego-kachestva-30.jpg"
        var components = URLComponents()
        components.scheme = "https"   //https - http
        components.host = "fikiwiki.com"    // api.unsplash.com - имя сайта
        components.path = "/uploads/posts/2022-02/1644865252_26-fikiwiki-com-p-skachat-kartinki-khoroshego-kachestva-30.jpg"
        return components.url!
    }
    
    func prepareHeaders() -> [String : String]? {
        nil
    }
    
    func prepareHhtpBody() -> Data? {
        nil
    }
}

class UploadImagAPI: APIProtocol {
    
    struct ImageModel {
        let key: String
        let data: Data
        
        init?(key: String, image: UIImage) {
            self.key = key
            //превращаем картинку в Data
            guard let data = image.pngData() else { return nil}
            //передаем полученную Data в    "let data"
            self.data = data
        }
    }
    
    var timeoutInterval: Double? = 10
    var httpMethpds: HttpMethods = .post
    
    func prepareParametr(searchTerm: String?) -> [String : String]? {
        nil
    }
    
    func crateURL(params: [String : String]?) -> URL {
        //let uloadUrl = "https://api.imgur.com/3/image"
        var components = URLComponents()
        components.scheme = "https"   //https - http
        components.host = "api.imgur.com"    // api.unsplash.com - имя сайта
        components.path = "/3/image"
        return components.url!
    }
    
    func prepareHeaders() -> [String : String]? {
        let httpHeaders = ["Authorization": "Client-ID 6206989d4a9f5c9"]
        return httpHeaders
    }
    
    func prepareHhtpBody() -> Data? {
        //картинка из проекта
        guard let image = UIImage(named: "110320381") else { return nil}
        //создаем экземпляр в котором содержится ключ + Data картинки
        guard let imageData = ImageModel(key: "image", image: image) else { return nil }
        
        return imageData.data
    }
}
