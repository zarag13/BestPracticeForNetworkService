//
//  NetworkBulder.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 17.08.2023.
//

import Foundation

protocol NetworkBulderProtocol {
    func getNetworkDataFetcher() -> NetworkDataFetcherProtocol?
    func postNetworkDataFetcher() -> NetworkDataFetcherProtocol?
}

class PhotoNetworkBulder:  NetworkBulderProtocol{
    func postNetworkDataFetcher() -> NetworkDataFetcherProtocol? {
        return nil
    }
    
    func getNetworkDataFetcher() -> NetworkDataFetcherProtocol? {
        let api = CreatePhotosAPI()
        let json = JSONCodable()
        let dataTask = CreateDataTask()
        let request = CreateRequest(api: api)
        let networkService = StaticNetworkService2(task: dataTask, staticRequest: request)
        let network = NetworkDataFetcher(network: networkService, jsoncodable: json, model: SearchResults.self)
        
        return network
    }
}

class PostsNetworkBulder: NetworkBulderProtocol {
    
    func getNetworkDataFetcher() -> NetworkDataFetcherProtocol? {
        let dataTask = CreateDataTask()
        let json = JSONCodable()
        let api = CreatePostsGetAPI()
        let request = CreateRequest(api: api)
        
        let networkService = StaticNetworkService2(task: dataTask, staticRequest: request)
        let network = NetworkDataFetcher(network: networkService, jsoncodable: json, model: [TestModelTable].self)
        return network
    }
    
     func postNetworkDataFetcher() -> NetworkDataFetcherProtocol? {
        let json = JSONCodable()
        let dataTask = CreateDataTask()
        let api = CreatePostsPostAPI()
        let request = CreateRequest(api: api)
        let networkService = StaticNetworkService2(task: dataTask, staticRequest: request)
        let network = NetworkDataFetcher(network: networkService, jsoncodable: json, model: [TestModelTable].self)
        return network
    }
}

class GetPostImageNetworkBulder: NetworkBulderProtocol {
    func getNetworkDataFetcher() -> NetworkDataFetcherProtocol? {
        let api = DownloadImageAndCache()
        let request = CreateRequest(api: api)
        let dataTask = CreateDataTask()
        let networkService = StaticNetworkService2(task: dataTask, staticRequest: request)
        let network = NetworkDataFetcher(network: networkService, jsoncodable: nil, model: [TestModelTable].self)
        return network
    }
    
    
    func postNetworkDataFetcher() -> NetworkDataFetcherProtocol? {
        let api = UploadImagAPI()
        let request = CreateRequest(api: api)
        let dataTask = CreateDataTask()
        
        let networkService = StaticNetworkService2(task: dataTask, staticRequest: request)
        let network = NetworkDataFetcher(network: networkService, jsoncodable: nil, model: [TestModelTable].self)
        return network
    }
}
