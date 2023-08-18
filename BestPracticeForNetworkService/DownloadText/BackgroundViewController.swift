//
//  BackgroundViewController.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 18.08.2023.
//

import UIKit

class BackgroundViewController: UIViewController {
    
    let dataProvider = CreateDownloadTask.shared
    
    private var filePath: String?

    private var alert: UIAlertController!
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(downloadButton)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
        
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 200),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        downloadButton.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        
        registerForNotification()
        dataProvider.fileLocation = { (path) in
            print("Download \(path.absoluteString)")
            self.filePath = path.absoluteString
            self.alert.dismiss(animated: false)
            self.postNotification()
        }
    }
    
    private func showAlert() {
        alert = UIAlertController(title: "Downloading..", message: "0%", preferredStyle: .alert)
        
        alert.view.translatesAutoresizingMaskIntoConstraints = false
        alert.view.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true) {
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2, y: self.alert.view.frame.height / 2 - size.height / 2)
            let activity = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activity.color = .gray
            activity.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))
            progressView.tintColor = .blue
            
            self.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self.alert.view.addSubview(activity)
            self.alert.view.addSubview(progressView)
        }
    }
    
    @objc func downloadAction() {
        showAlert()
        dataProvider.startDownload()
    }
}

extension BackgroundViewController {
    //запрос на разрешение отправки уведомлений
    //вызывается в viewDidLoad
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            
        }
    }
    
    //вызывается после завершения загрузки
    private func postNotification() {
        let content = UNMutableNotificationContent()
        //текст уведомления
        content.title = "Download complete!"
        //описание
        content.body = "Your file in path: \(filePath!)"
        //через 3 секнды после окончания загрузки файлы
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        //оправка уведомления - объеденяем контент и задержку
        let request = UNNotificationRequest(identifier: "TrasferComplete", content: content, trigger: trigger)
        //добавляем это уведомление
        UNUserNotificationCenter.current().add(request)
    }
}
