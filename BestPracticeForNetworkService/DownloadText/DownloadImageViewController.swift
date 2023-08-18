//
//  DownloadImageViewController.swift
//  TestNetworking
//
//  Created by Kirill on 26.07.2023.
//

import UIKit

class DownloadImageViewController: UIViewController {

    let imageView = UIImageView()
    let button = UIButton()
    let aactivityIndicator = UIActivityIndicatorView()
    
    var networkManager: NetworkBulderProtocol = GetPostImageNetworkBulder()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.view.backgroundColor = .white
    }
    
    
    func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "DownloadImage"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(uploadImage))
        
        button.setTitle("Tap to Download an Image", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tupButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        aactivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        aactivityIndicator.style = .large
        aactivityIndicator.color = .red
        aactivityIndicator.hidesWhenStopped = true
        
        self.view.addSubview(imageView)
        self.view.addSubview(button)
        self.view.addSubview(aactivityIndicator)
        
        setupLayout()
    }
    
    @objc func uploadImage() {
        let post = networkManager.postNetworkDataFetcher()
        post?.postData(complition: { json in
            guard let fetchPhotos = json else { return }
            print(fetchPhotos)
        })
    }
    
    @objc func tupButton() {
        button.isHidden = true
        aactivityIndicator.startAnimating()
        
        let imageData = networkManager.getNetworkDataFetcher()
        imageData?.getImage(complition: { data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.aactivityIndicator.stopAnimating()
                self.imageView.image = UIImage(data: data)
            }
        })
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            aactivityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            aactivityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }

}
