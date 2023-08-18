//
//  DownloadDataFetcher.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 18.08.2023.
//

import Foundation
import UIKit

protocol CreateTaskProtocol {
    func createDataTask() -> URLSession
}


class CreateDownloadTask: NSObject, CreateTaskProtocol {
    
    static let shared = CreateDownloadTask()
    private override init() { }
    
    var downloadTask : URLSessionDownloadTask!
    
    var fileLocation: ((URL) -> Void)?
    
    var onProgress: ((Double) -> Void)?
    
    
    func createDataTask() -> URLSession {
        //сессия для фоновой загрузки
        
        let config = URLSessionConfiguration.background(withIdentifier: "com.myorganizationApp.TestNetworking")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        return session
    }
    
    func startDownload() {
        if let url = URL(string: "https://sabnzbd.org/tests/internetspeed/50MB.bin") {
            downloadTask = createDataTask().downloadTask(with: url)
            downloadTask.earliestBeginDate = Date().addingTimeInterval(1)
            downloadTask.countOfBytesClientExpectsToSend = 512
            downloadTask.countOfBytesClientExpectsToReceive = 50*1024*1024 //50MB
            downloadTask.resume()
        }
    }
    
    func stopDownload() {
        downloadTask.cancel()
    }
}

extension CreateDownloadTask: URLSessionDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let completionHandler = appDelegate.bgSessionCompletionHandlet else { return }
            
            appDelegate.bgSessionCompletionHandlet = nil
            completionHandler()
        }
    }
}


extension CreateDownloadTask: URLSessionDownloadDelegate {
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finish downloading: \(location.absoluteString)")
        
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Download progress: \(progress)")
        
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
